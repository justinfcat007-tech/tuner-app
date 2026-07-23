# Tuner Pro：海外增长前端设计交接

> 交接对象：Claude Code  
> 技术栈：Vue 3、TypeScript、Vue Router、现有 scoped CSS；不要引入 UI 框架。  
> 目标：先让免费调音器获得安装与留存，再在用户已获得价值后引导订阅。此文档只定义前端体验；不得接入或伪造支付成功。

## 1. 产品边界与原则

### 用户与产品策略

- 首发语言为英文，面向手机优先的海外用户。
- 免费层必须能完成真实的基础调音：不能给基础准确度、降噪或标准调弦加锁。
- `Pro` 只解锁高频/专业使用场景：无广告、自定义调弦、更多乐器、历史记录、校准/音律预设、教学模式。
- 不在首次打开、麦克风授权前或调音过程中打断用户售卖。
- 首次升级入口仅在下列情境出现：完成 3 次有效调音；点击锁定的高级功能；进入 Profile/Pro。
- 不能使用倒计时、假折扣、预选高价套餐或误导性关闭按钮。

### 非目标

- 本任务不实现 Google Play Billing、StoreKit、后端订单或模拟支付。
- 当前后端的模拟支付接口不能从新页面调用。
- 不创建广告位、插屏或奖励广告。

## 2. 设计方向

**主题：Warm Acoustic Precision**。调音页继续使用深色、低干扰仪表风格；Pro 页面使用温暖木色、奶油色和克制金色，避免奢侈品式“VIP”视觉。

视觉关键词：可信、专注、带有乐器质感、可读性优先。

使用 [design-tokens.json](./design-tokens.json) 中的颜色、间距、圆角和字体 token；不要在组件内散落新的十六进制颜色。

## 3. 信息架构与路由

| 路由 | 组件建议 | 用途 |
|---|---|---|
| `/` | `TunerView.vue` | 乐器选择；显示克制的 Pro 入口 |
| `/guitar`、`/ukulele`、`/yangqin` | 现有调音页 | 主价值页；仅在高级入口显示锁定状态 |
| `/pro` | 新建 `ProView.vue` | 免费用户的订阅介绍与套餐选择 |
| `/tuning-library` | 新建 `TuningLibraryView.vue` | 常用/高级/自定义调弦库 |
| `/profile` | 新建 `ProfileView.vue` | Pro 状态、恢复购买、语言、隐私入口 |
| `/vip` | 保留兼容路由 | 重定向至 `/pro`，不要继续渲染旧套餐页 |

现有登录守卫可保持不变。若当前应用仍要求登录，`/pro` 也遵守它；以后允许游客使用时，不应让登录阻塞免费调音。

## 4. 页面规格

### A. Home / Instrument selector

目标：让用户在 3 秒内开始调音。

```text
┌──────────────────────────────────┐
│ TUNER                      [PRO] │
│ Tune with confidence, anywhere.  │
│                                  │
│ [ Guitar       Standard tuning ] │
│ [ Ukulele      G–C–E–A          ] │
│ [ Yangqin      Explore          ] │
│                                  │
│  More instruments & custom      │
│  tunings are available in Pro.  │
│                      Explore Pro │
└──────────────────────────────────┘
```

- 顶部 `PRO` 是描边胶囊，不使用“Upgrade VIP”。
- 乐器卡片完整可用；不应因用户免费而遮罩吉他、尤克里里或扬琴。
- 底部 Pro 信息卡只在免费用户显示，点击进入 `/pro`。
- 英文文案：`Tune with confidence, anywhere.`、`Explore Pro`。

### B. Tuner page

保持现有音高仪表和弦选择为视觉焦点。新增一个不打断主流程的 `UtilityBar`：

```text
[ Standard ▼ ]  [ 440 Hz ]  [ Custom tuning 🔒 ]
```

- `Standard` 与 `440 Hz` 永远免费。
- 点击 `Custom tuning` 时显示 `FeatureGateSheet`，不离开当前选择的弦。
- 完成有效调音后仅显示一次小型确认条：`Nice work — your guitar is in tune.`；第三次完成后可在其下出现文字链接 `Save custom tunings with Pro`。
- 调音时禁止显示全屏购买弹窗、广告或自动跳转。

### C. FeatureGateSheet（底部弹层）

触发：点击任意高级能力，例如自定义调弦、更多乐器、调音历史。

```text
┌──────────────────────────────────┐
│  ×                               │
│  Make every tuning yours          │
│  Save alternate tunings and get   │
│  back to them in one tap.         │
│                                  │
│  ✓ Unlimited custom tunings       │
│  ✓ Alternate & drop tunings       │
│  ✓ Ad-free practice tools         │
│                                  │
│  [ See Tuner Pro ]                │
│  Not now                          │
└──────────────────────────────────┘
```

- 最大宽度 480px；底部圆角 24px；背景遮罩 48%。
- `Not now` 为可见文字按钮；关闭后在 7 天内不要对同一功能再次自动触发。
- 根据入口替换首句和三项权益，CTA 始终进入 `/pro`。

### D. ProView（核心转化页）

```text
┌──────────────────────────────────┐
│ ←                                 │
│ TUNER PRO                         │
│ Tune more. Practice longer.       │
│                                  │
│  ● No ads                         │
│  ● Custom & alternate tunings     │
│  ● More instruments and tools     │
│                                  │
│  [Monthly] [Yearly · Save 44%]    │
│ ┌──────────────────────────────┐ │
│ │ YEARLY       BEST VALUE      │ │
│ │ $19.99 / year                │ │
│ │ Less than $1.67 / month      │ │
│ └──────────────────────────────┘ │
│                                  │
│ [ Start 7-day free trial ]        │
│ Cancel anytime. Then $19.99/year. │
│ Restore purchase                  │
│ Terms  ·  Privacy                 │
└──────────────────────────────────┘
```

- 默认选中年付，但月付与年付卡片具有同等可见性。
- 首发 mock 价格：`monthly = $2.99/month`、`yearly = $19.99/year`。价格以 `Intl.NumberFormat` 格式化，不能硬编码美元符号到组件。
- 年付标识使用 `Best value`，不使用“Limited time”或假节省。
- 试用期信息必须紧邻主 CTA，清楚说明试用结束后的价格与周期。
- `Start 7-day free trial` 调用一个 `BillingAdapter`；当 billing 未接入，显示轻量 toast：`Purchases are not available in this build yet.`，不得创建订单、修改 Pro 状态或跳转订单页。
- `Restore purchase` 在 adapter 未接入时显示同类 toast。
- 隐私与条款用真实路由或临时外链常量，不能使用 `#`。

### E. Tuning Library

```text
My tunings                         [+ Create] (Pro)
Popular
[ Standard E A D G B E ]
[ Drop D    D A D G B E ]          [PRO]
[ DADGAD    D A D G A D ]          [PRO]
Explore instruments
[ Bass ] [ Mandolin ] [ Banjo ]    [PRO]
```

- `Standard` 必须免费。
- Pro 卡片可浏览其说明，但点击只进入 FeatureGateSheet，不改变当前调音状态。
- 可访问性：锁定能力需要文字 `Pro`，不能只依赖锁形图标。

### F. Profile

- 免费：显示 `Free plan` 和 `Explore Tuner Pro`。
- 已订阅：显示 `Tuner Pro`、权益摘要、`Manage subscription`、`Restore purchase`。
- 包含 `Privacy policy`、`Terms of use`、`Delete account`、`Send feedback`；账户删除采用二次确认，不在本任务实现后端删除。

## 5. 组件、状态与接口契约

### 必做组件

| 组件 | Props / 行为 |
|---|---|
| `ProBadge` | `compact?: boolean`；可进入 `/pro` |
| `PlanSelector` | `plans`、`modelValue`、`@update:modelValue` |
| `FeatureGateSheet` | `feature: ProFeature`、`open`、`@close`、`@explore` |
| `ProFeatureList` | 使用图标 + 文本，不使用 emoji |
| `TuningPresetCard` | `preset`、`locked`、`@select`、`@locked` |
| `ToastMessage` | 支持 `info`、`success`、`error`；可被 billing stub 使用 |

### 建议类型

```ts
export type EntitlementStatus = 'free' | 'trial' | 'active' | 'expired'
export type BillingState = 'available' | 'unavailable' | 'loading' | 'error'
export type ProFeature =
  | 'custom-tunings'
  | 'alternate-tunings'
  | 'instrument-library'
  | 'practice-history'
  | 'ad-free'

export interface SubscriptionPlan {
  id: 'monthly' | 'yearly' | 'lifetime'
  period: 'month' | 'year' | 'lifetime'
  price: number
  currency: string
  trialDays?: number
  badge?: string
}

export interface BillingAdapter {
  state: Readonly<Ref<BillingState>>
  purchase(planId: SubscriptionPlan['id']): Promise<void>
  restore(): Promise<void>
}
```

首轮只实现 `UnavailableBillingAdapter`。后续 Android/iOS 分别实现 Google Play Billing / StoreKit 的适配器，服务端只依据商店校验后的权益更新 `EntitlementStatus`。

## 6. 埋点（事件名必须稳定）

| 事件 | 触发条件 | 必填属性 |
|---|---|---|
| `tuner_completed` | 得到稳定且有效的调音结果 | `instrument`, `target_note`, `cents`, `session_count` |
| `pro_entry_viewed` | 展示 Pro 入口 | `source` |
| `feature_gate_viewed` | 打开高级功能弹层 | `feature`, `source` |
| `pro_viewed` | 打开 `/pro` | `source`, `entitlement_status` |
| `plan_selected` | 切换月/年/终身方案 | `plan_id`, `source` |
| `purchase_started` | 调用 billing adapter 前 | `plan_id` |
| `purchase_result` | adapter 返回后 | `plan_id`, `result`, `error_code?` |

不要在事件中发送音频、邮箱、JWT、完整设备标识或用户输入内容。

## 7. 响应式与可访问性

- 主断点：360px、390px、480px；桌面预览最大宽度 480px。
- 最小可点击区域：44 × 44px；文本对比度至少 4.5:1。
- 所有图标按钮具有 `aria-label`；弹层打开后焦点进入弹层，关闭后返回触发元素。
- PlanSelector 使用真实 `button` 或 radio 语义，键盘可切换。
- 所有金额和试用/续费信息必须为可选择的真实文本，不绘制到图片里。
- 尊重 `prefers-reduced-motion`；动画只用于 150–220ms 的淡入/选中态。

## 8. Claude Code 实施顺序与验收

1. 添加 token 文件、基础 `AppShell`、toast 和 `ProBadge`。
2. 新建 `/pro` 和兼容 `/vip → /pro`，删除旧 VIP 页面对 `payAPI` 的直接调用。
3. 添加 FeatureGateSheet 与 Tuning Library 的 mock 数据和锁定状态。
4. 在现有三类调音页插入非打断式高级入口；不能破坏麦克风、稳定判音、自动选弦。
5. 添加 BillingAdapter stub 与上表埋点调用点。
6. `npm run build` 必须通过；手动验证 360px、390px、480px，不应横向滚动。

验收清单：

- [ ] 新用户能直接开始调音，未见强付费墙。
- [ ] 基础标准调弦无需 Pro。
- [ ] 锁定高级功能后能解释权益，并可明显关闭。
- [ ] Pro 页面准确展示方案、试用期与续费价格。
- [ ] 点击购买不会调用 `payAPI.createOrder`、不会伪造订单或会员状态。
- [ ] 所有现有调音页仍可构建，音频权限流程不变。
- [ ] `/vip` 访问会去往新的 Pro 体验。
