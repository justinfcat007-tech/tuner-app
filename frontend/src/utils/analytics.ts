/**
 * 埋点系统 - 事件名必须稳定
 * 不要在事件中发送音频、邮箱、JWT、完整设备标识或用户输入内容
 */

type AnalyticsEvent =
  | 'tuner_completed'
  | 'pro_entry_viewed'
  | 'feature_gate_viewed'
  | 'pro_viewed'
  | 'plan_selected'
  | 'purchase_started'
  | 'purchase_result'

export function track(event: AnalyticsEvent, props?: Record<string, unknown>) {
  // 首轮只打日志，后续接入真实埋点 SDK
  console.log('[analytics]', event, props || '')
}
