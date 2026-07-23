# 外网发布

## 1. 准备域名与服务器

将域名的 A/AAAA 记录指向服务器公网 IP，并在防火墙中仅开放 TCP `80`、`443`。不要对公网开放 MySQL 或后端 `8080` 端口。

服务器需安装 Docker Engine 和 Docker Compose 插件。

## 2. 配置生产密钥

在仓库根目录复制示例文件：

```bash
cp .env.production.example .env.production
```

填写真实域名、数据库密码和至少 32 位随机 `JWT_SECRET`。该文件不得提交到版本控制。

支付目前是模拟实现。发布前保持 `PAYMENTS_ENABLED=false`；在真实支付服务接入、支付回调验签、订单金额校验和幂等处理完成前，不能开放收费。

## 3. 启动服务

```bash
docker compose --env-file .env.production up -d --build
docker compose ps
curl https://your-domain.example/health
```

Compose 默认将 `.env.production` 注入 API 容器；如需使用其他文件，可在命令前设置 `ENV_FILE`。

Caddy 会自动申请并续期 HTTPS 证书。首次启动前确保域名已经解析到该服务器，且 80/443 端口可从公网访问。

前端会构建为 `https://<DOMAIN>/api`，网页和 Android APK 都使用同一个正式 API。后端只允许该 HTTPS 域名及 Capacitor 本地来源跨域访问。

## 4. 构建 Android APK

在本机 `frontend` 目录执行：

```powershell
npm install
npm run build
npx cap sync android
npx cap open android
```

Android Studio 中选择 **Build > Generate Signed Bundle / APK**。首次创建 keystore 后应离线备份；后续更新同一 App 必须使用同一把签名密钥。

首次发布前，将 `frontend/capacitor.config.ts` 中的 `appId` 改成你自己拥有的反向域名（例如 `com.yourcompany.tuner`）；发布后不能随意更改，否则 Android 会将其视为另一款应用。

在真机上检查：登录、所有 API、麦克风授权、调音检测、断网状态和退出登录。Google Play 发布使用 AAB，而直接分发可以使用已签名 APK。
