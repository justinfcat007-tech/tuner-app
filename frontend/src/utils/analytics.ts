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

interface AnalyticsProperties {
  tuner_completed?: { instrument: string; target_note: string; cents: number; session_count: number }
  pro_entry_viewed?: { source: string }
  feature_gate_viewed?: { feature: string; source: string }
  pro_viewed?: { source: string; entitlement_status: string }
  plan_selected?: { plan_id: string; source: string }
  purchase_started?: { plan_id: string }
  purchase_result?: { plan_id: string; result: string; error_code?: string }
}

export function track(event: AnalyticsEvent, props?: Record<string, unknown>) {
  // 首轮只打日志，后续接入真实埋点 SDK
  console.log('[analytics]', event, props || '')
}
