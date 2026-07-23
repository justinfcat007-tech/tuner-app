import type { Ref } from 'vue'

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
