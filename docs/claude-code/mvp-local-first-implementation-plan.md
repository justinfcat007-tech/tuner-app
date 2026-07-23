# Claude Code 修改计划：海外首发 MVP（Local-first）

> 目标：将当前项目调整为可直接上架测试的免费调音器第一版。  
> 核心策略：**不部署后端、不要求登录、不接支付、不展示广告**。调音、筛选、基础调弦与设置全部离线可用。  
> 本计划是实现任务清单，不是重新设计产品；视觉细节仍以 [overseas-growth-ui-brief.md](./overseas-growth-ui-brief.md) 为准。

## 0. 不可违反的约束

- 不删除 `backend/`，不删除现有 API 类型；仅让 MVP 前端不依赖它们。
- 不调用 `payAPI`、`payAPI.createOrder`、真实支付 SDK 或任何模拟支付逻辑。
- 不把游客强制带到 `/login`。
- 不上传、录制、缓存或分析原始麦克风音频。
- 不引入广告 SDK、分析 SDK、第三方登录 SDK 或 UI 框架。
- 首次启动必须生成匿名安装批次信息，为后续商业化迁移做准备；不得把它作为永久付费权益的唯一凭证。
- 现有 `usePitchDetector` 的滤波、稳定判音和麦克风停止清理逻辑不得退化。
- 所有首次用户可在离线状态下进入吉他、尤克里里、扬琴调音页。

## 1. 首发范围

### 必须提供

- 游客可直接调音。
- 吉他、尤克里里、扬琴。
- 基础标准调弦、弦选择、当前目标音、440/442Hz（已有功能保留）。
- 本地保存的设置：语音提示、最后使用的乐器、A4 基准音、自动/手动选弦偏好。
- 麦克风权限被拒绝时的英文说明与再次尝试按钮。
- 英文界面、隐私政策页、支持/反馈入口。
- 一个只读的 `Tuner Pro` 介绍页：可浏览权益，但购买按钮显示 `Coming soon`，不产生订单。

### 明确延后

- 登录、注册、账户资料、订单、VIP 到期时间。
- 跨设备同步、调音历史云备份。
- Google Play Billing、App Store StoreKit、试用、恢复购买。
- 广告、推送、行为分析、邀请系统。
- 任何需要后端或公开 API 的功能。

## 2. 建议实施顺序

### Step 1 — 本地状态层

新增 `frontend/src/composables/useLocalPreferences.ts`。

要求：

```ts
export interface LocalPreferences {
  lastInstrument: 'guitar' | 'ukulele' | 'yangqin'
  a4Reference: 440 | 442 | 443
  voiceEnabled: boolean
  autoSelectString: boolean
  hasSeenMicEducation: boolean
}
```

同时新增独立的安装批次记录，键名为 `tuner.install.v1`：

```ts
export interface InstallCohort {
  installationId: string
  firstInstalledAt: string // ISO 8601
  firstSeenVersion: string
  cohort: 'early-access' | 'standard'
}
```

- 第一次打开 MVP 时创建记录，`cohort` 固定为 `early-access`。
- `installationId` 优先使用 `crypto.randomUUID()`；不支持时可生成等价随机 ID。
- `firstSeenVersion` 来自 `VITE_APP_VERSION`，未定义时使用 `'1.0.0'`。
- 已存在该记录时绝不能重写 `firstInstalledAt`、`firstSeenVersion` 或 `cohort`。
- 该数据仅存设备本地，不上传、不用于广告定向、不包含账户、设备硬件或音频信息。
- 提供只读 `installCohort`，供未来升级页或本地无广告宽限期判断使用；MVP 页面不主动展示它。

- 使用 `localStorage`，键名统一为 `tuner.preferences.v1`。
- 解析失败、缺字段或旧版本数据时回退到安全默认值。
- 除上述偏好外，不保存麦克风数据、音高帧或用户身份数据。
- 为所有乐器页提供单一的 `preferences`、`updatePreferences`、`resetPreferences` 接口，避免页面分别写 `localStorage`。

### Step 2 — 路由改为游客可用

修改 `frontend/src/router/index.ts`：

- 将 `/`、`/guitar`、`/ukulele`、`/yangqin`、`/pro`、`/privacy`、`/support` 标为公开路由。
- 删除或绕开这些路由的 `requiresAuth` 守卫。
- 不删除 `/login`、`/orders` 等旧路由；但 MVP 首页不能展示它们的入口。
- `/vip` 重定向到 `/pro`，`/orders` 保持非入口状态即可。
- 登录页若保留，显示 `Account sync is coming later.`，不要成为默认页面。

### Step 3 — 首页改为英文游客体验

重构 `frontend/src/views/TunerView.vue`：

- 删除对 `localStorage.user`、`UserInfo` 和 `/vip` 的依赖。
- 标题：`TUNER`；副标题：`Tune with confidence, anywhere.`
- 乐器卡片英文为 `Guitar`、`Ukulele`、`Yangqin`，可保留中文小字作为辅助而非主文案。
- 使用 `useLocalPreferences` 高亮最后使用的乐器；用户点击任意卡片后写入 `lastInstrument`。
- 页脚提供 `Privacy` 与 `Support` 链接；不显示订单或升级 VIP。
- 可放置低干扰链接 `Explore Tuner Pro`，进入 `/pro`。

### Step 4 — 调音页接入本地偏好与权限状态

修改 `GuitarTuner.vue`、`UkuleleTuner.vue`、`YangqinTuner.vue`：

- 用 `useLocalPreferences` 初始化 A4、语音和自动选择状态；修改时立即写回。
- 所有可见主文案使用英文，包括 `Listening…`、`Waiting for a stable note…`、`Too low — tighten`、`Too high — loosen`、`In tune`。
- `start()` 失败时，`usePitchDetector` 需暴露可读错误状态，例如 `microphone-denied`、`microphone-unavailable`。
- 页面针对错误状态显示信息卡：
  - 标题：`Microphone access is needed`
  - 正文：`Allow microphone access to tune your instrument. Audio stays on this device.`
  - 按钮：`Try again`
- 离开页面必须继续调用 `stop()`，以释放麦克风。
- 不在调音过程中显示 Pro 弹层或购买 CTA。

### Step 5 — 只读 Pro 页面

新建 `frontend/src/views/ProView.vue`：

- 使用 [overseas-growth-ui-brief.md](./overseas-growth-ui-brief.md) 中的视觉 token 和文案。
- 显示未来权益：`Custom tunings`、`Alternate tunings`、`More instruments`、`Practice history`、`Ad-free tools`。
- 套餐卡可展示，但所有 CTA 统一为禁用/只读状态：`Coming soon`。
- 点击 CTA 显示 toast：`Tuner Pro is coming soon. The core tuner is free to use.`
- 不导入 `payAPI`，不读取 `user`，不伪造 Pro 状态。
- 页面底部链接至 `/privacy` 和 `/support`。

### Step 6 — 静态隐私与支持页面

新建：

- `frontend/src/views/PrivacyView.vue`
- `frontend/src/views/SupportView.vue`

隐私页 MVP 文案必须准确表述：

- 麦克风音频仅用于设备本地音高检测，不上传或保存原始录音。
- 应用在 MVP 不要求账户，不使用广告或第三方分析 SDK。
- 本地偏好保存于设备的本地存储中，用户可通过清除应用数据删除。
- 提供版本号、最后更新日期和联系邮箱占位常量（`support@YOUR_DOMAIN`）；上线前由人工替换为真实邮箱与域名。

支持页内容：常见麦克风问题、离线使用说明、`mailto:` 反馈链接、隐私页链接。

### Step 7 — 清理 MVP 可见入口

- `VIPView.vue` 和 `OrdersView.vue` 可保留源文件，但不能从首页、调音页或底部导航进入。
- 在任何 MVP 路径中不得调用 `authAPI`、`payAPI`。
- 新增一个简单的 `isMvpMode` 常量或 `VITE_MVP_MODE=true` 环境变量；默认在首发构建中为 `true`。
- 若使用 feature flag，必须在构建期确定，不能在运行时向服务器请求配置。

### Step 8 — Android 与发布前检查

- 保留 `RECORD_AUDIO` 与 `INTERNET` 权限。
- 使用 `npm run android:sync` 更新 Android 资源。
- 启动时不依赖网络：飞行模式下仍能进入并使用调音器。
- 因为 MVP 没有网络 API，`VITE_API_BASE_URL` 不应成为运行前提。
- 在隐私政策页和商店资料中声明麦克风的本地使用目的。

## 3. 后续商业化迁移规则（现在实现数据基础，未来版本再启用）

### 用户承诺

第一版对所有用户承诺：基础调音永久免费。未来版本不得将以下已免费能力改为付费或广告强制解锁：

- 吉他、尤克里里、扬琴的基础调音。
- 麦克风采集、滤波、稳定判音、高/低/准反馈。
- 标准调弦、基础弦选择与 440/442/443Hz 基准音。

未来只可对**新增加的 Pro 能力**收费：自定义调弦、替代/降调调弦、更多乐器、练习历史、云同步、教学工具和无广告体验。

### 建议版本节奏

| 版本 | 新用户 | `early-access` 用户 |
|---|---|---|
| v1.0 | 免费、无广告、离线调音 | 免费、无广告、离线调音 |
| v1.1 | 免费核心 + Pro 功能预告 | 相同体验，无强制升级 |
| v1.2 | 免费核心 + 可选轻量广告 + Pro | 更新后 90 天无广告，获得创始人价格 |
| v1.3+ | 商店订阅/终身购买 | 基础功能永久免费；可领取一次创始人优惠 |

### 广告规则

- 禁止在调音中、麦克风授权、等待声音稳定、音准反馈或错误恢复期间展示广告。
- 如后续接入广告，只允许首页、调弦库、设置页等非关键区域的低干扰展示。
- `early-access` 用户从首次引入广告的更新起，至少获得 90 天无广告；这仅是设备本地优惠，文案不得承诺跨设备或永久有效。
- 广告 SDK 加入前必须重新审查 Privacy Policy、Google Play Data safety 和 App Store Privacy 标签。

### 订阅与权益规则

- 接入付费时使用 Google Play Billing / StoreKit；不得继续调用当前项目的模拟订单 API。
- 永久/跨设备 Pro 权益必须以商店订单和服务端校验为准。
- 本地 `InstallCohort` 仅用于识别升级时仍在同一设备上的早期用户，不能单独授予“终身 Pro”。
- 后续引入账户时，提供一个有限期的 `Claim founder offer` 流程；绑定账户前清楚说明该优惠仅可领取一次。

### 升级测试场景

商业化版本开发时必须测试：

1. 安装 v1.0，完成若干调音，再覆盖安装 v1.2：`firstInstalledAt` 不变，用户获得本地无广告宽限期。
2. v1.2 全新安装：`cohort` 为 `standard`，但仍可免费使用基础调音。
3. 清除应用数据或卸载重装：不保证保留本地早期资格；页面不应承诺永久资格。
4. 已订阅用户恢复购买：以商店和服务端权益为准，不依赖 `localStorage`。
5. 离线状态：基础调音可用；付费/广告配置失败时默认不阻塞调音。

## 4. 建议新增/修改文件清单

```text
frontend/src/composables/useLocalPreferences.ts       (new)
frontend/src/views/ProView.vue                        (new)
frontend/src/views/PrivacyView.vue                    (new)
frontend/src/views/SupportView.vue                    (new)
frontend/src/components/ToastMessage.vue              (new, optional)
frontend/src/router/index.ts                           (modify)
frontend/src/views/TunerView.vue                       (modify)
frontend/src/views/GuitarTuner.vue                     (modify)
frontend/src/views/UkuleleTuner.vue                    (modify)
frontend/src/views/YangqinTuner.vue                    (modify)
frontend/src/composables/usePitchDetector.ts           (modify: error state only)
frontend/src/style.css                                 (modify: shared tokens/reset only)
frontend/src/views/VIPView.vue                         (do not use in MVP)
```

## 5. 验收清单

Claude Code 完成后必须提供：修改文件清单、`npm run build` 输出，以及 360px/390px/480px 截图。

- [ ] 清空浏览器 Local Storage 后访问 `/`，不跳转 `/login`。
- [ ] 断网状态下可进入三种调音器并开始本地调音。
- [ ] 拒绝麦克风后可见英文错误卡，点击 `Try again` 可以重新请求授权。
- [ ] A4、语音提示、自动选弦、最后乐器在刷新后保留。
- [ ] 首次启动创建 `tuner.install.v1`；刷新和覆盖安装模拟场景不会重置早期用户批次数据。
- [ ] 首页和调音页面没有订单、登录强制、VIP 套餐或支付按钮。
- [ ] `/pro` 为只读说明页，所有 CTA 不调用任何 API。
- [ ] `/privacy` 明确说明音频仅在本地处理；`/support` 有可用的反馈入口。
- [ ] `npm run build` 与 `npm run android:sync` 均成功。
- [ ] 不增加任何网络请求到调音关键路径。

## 6. 交给 Claude Code 的执行提示

```text
请严格执行 docs/claude-code/mvp-local-first-implementation-plan.md。
这是离线优先的海外首发 MVP：游客可直接调音，不部署后端，不调用认证、订单或支付 API。
实现 tuner.install.v1 安装批次记录，为未来广告/订阅的早期用户迁移做准备；但 MVP 不显示广告、不出售 Pro、不向服务器上传该记录。
请先阅读 docs/claude-code/overseas-growth-ui-brief.md 和 design-tokens.json；前者的 Pro 页面设计在 MVP 中只能作为 Coming soon 展示。
保持 Vue 3 + TypeScript + scoped CSS，不引入 UI/广告/分析 SDK。
完成后运行 npm run build 和 npm run android:sync，给出改动摘要、验证结果与截图。
```
