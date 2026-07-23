import { ref, type Ref } from 'vue'
import type { BillingAdapter, BillingState, SubscriptionPlan } from '../types/growth'
import { track } from '../utils/analytics'

type ToastLike = { show: (msg: string, type?: unknown, duration?: unknown) => void }

/**
 * UnavailableBillingAdapter - 首轮 stub
 * 不接入真实支付，显示 toast 提示
 */
export class UnavailableBillingAdapter implements BillingAdapter {
  state: Readonly<Ref<BillingState>>
  private toast: ToastLike | null

  constructor(toast?: ToastLike) {
    this.state = ref<BillingState>('unavailable')
    this.toast = toast || null
  }

  async purchase(planId: SubscriptionPlan['id']): Promise<void> {
    track('purchase_started', { plan_id: planId })
    track('purchase_result', { plan_id: planId, result: 'unavailable' })
    this.toast?.show('Purchases are not available in this build yet.', 'info')
  }

  async restore(): Promise<void> {
    track('purchase_result', { plan_id: 'restore', result: 'unavailable' })
    this.toast?.show('Purchases are not available in this build yet.', 'info')
  }
}

// 共享实例（延迟初始化，需要 toast ref）
let adapterInstance: UnavailableBillingAdapter | null = null

export function getBillingAdapter(toast?: ToastLike): BillingAdapter {
  if (!adapterInstance) {
    adapterInstance = new UnavailableBillingAdapter(toast)
  }
  return adapterInstance
}

export function resetBillingAdapter(): void {
  adapterInstance = null
}
