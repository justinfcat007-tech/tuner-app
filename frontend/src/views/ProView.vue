<template>
  <div class="pro-page">
    <header class="pro-header">
      <button class="pro-back" @click="$router.back()" aria-label="Go back">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M15 18l-6-6 6-6"/>
        </svg>
      </button>
    </header>

    <div class="pro-content">
      <h1 class="pro-brand">TUNER PRO</h1>
      <p class="pro-tagline">Tune more. Practice longer.</p>

      <ProFeatureList :items="proFeatures" />

      <PlanSelector
        v-model="selectedPlan"
        :plans="plans"
        @update:model-value="onPlanSelect"
      />

      <button class="pro-cta" @click="onStartTrial">
        Start 7-day free trial
      </button>
      <p class="pro-cta-sub">
        Cancel anytime. Then {{ yearlyPriceFormatted }}/year.
      </p>

      <button class="pro-restore" @click="onRestore">
        Restore purchase
      </button>

      <div class="pro-legal">
        <a href="/privacy" class="pro-legal-link">Privacy</a>
        <span class="pro-legal-sep">·</span>
        <a href="/terms" class="pro-legal-link">Terms</a>
      </div>
    </div>

    <ToastMessage ref="toastRef" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import PlanSelector from '../components/PlanSelector.vue'
import ProFeatureList from '../components/ProFeatureList.vue'
import ToastMessage from '../components/ToastMessage.vue'
import { getBillingAdapter } from '../services/billing'
import { track } from '../utils/analytics'
import type { SubscriptionPlan } from '../types/growth'

const toastRef = ref<InstanceType<typeof ToastMessage>>()
const selectedPlan = ref<SubscriptionPlan['id']>('yearly')

const proFeatures = [
  'No ads',
  'Custom & alternate tunings',
  'More instruments and tools',
]

const plans: SubscriptionPlan[] = [
  { id: 'monthly', period: 'month', price: 2.99, currency: 'USD' },
  { id: 'yearly', period: 'year', price: 19.99, currency: 'USD', trialDays: 7, badge: 'Best value' },
]

const yearlyPriceFormatted = computed(() => {
  const yearly = plans.find(p => p.id === 'yearly')
  if (!yearly) return '$19.99'
  try {
    return new Intl.NumberFormat('en-US', { style: 'currency', currency: yearly.currency }).format(yearly.price)
  } catch { return '$19.99' }
})

onMounted(() => {
  track('pro_viewed', { source: 'route', entitlement_status: 'free' })
})

function onPlanSelect(planId: SubscriptionPlan['id']) {
  track('plan_selected', { plan_id: planId, source: 'pro_page' })
}

async function onStartTrial() {
  track('purchase_started', { plan_id: selectedPlan.value })
  const adapter = getBillingAdapter(toastRef.value || undefined)
  await adapter.purchase(selectedPlan.value)
}

async function onRestore() {
  const adapter = getBillingAdapter(toastRef.value || undefined)
  await adapter.restore()
}
</script>

<style scoped>
.pro-page {
  background: var(--color-canvas, #10151D);
  min-height: 100vh;
  color: var(--color-text-primary, #F8FAFC);
  max-width: 480px;
  margin: 0 auto;
}
.pro-header {
  padding: 16px;
}
.pro-back {
  width: 44px; height: 44px;
  background: none; border: none;
  color: var(--color-text-primary, #F8FAFC);
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  border-radius: 50%;
  transition: background var(--motion-fast, 150ms);
}
.pro-back:hover { background: rgba(255,255,255,0.08); }
.pro-content {
  padding: 24px 24px 48px;
}
.pro-brand {
  font-family: var(--font-display, Georgia);
  font-size: var(--size-display, 34px);
  font-weight: 700;
  color: var(--color-accent, #E7B65C);
  margin: 0 0 8px;
  letter-spacing: 2px;
}
.pro-tagline {
  font-size: var(--size-body-large, 17px);
  color: var(--color-text-secondary, #B8C2CC);
  margin: 0 0 24px;
}
.pro-cta {
  display: block;
  width: 100%;
  padding: 16px;
  background: var(--color-accent, #E7B65C);
  color: var(--color-ink, #1A222C);
  border: none;
  border-radius: var(--radius-sm, 10px);
  font-size: 17px;
  font-weight: 700;
  cursor: pointer;
  margin-top: 24px;
  transition: background var(--motion-fast, 150ms);
}
.pro-cta:hover { background: var(--color-accent-strong, #C98B32); }
.pro-cta-sub {
  font-size: var(--size-caption, 12px);
  color: var(--color-text-muted, #7F8A96);
  text-align: center;
  margin: 12px 0 0;
}
.pro-restore {
  display: block;
  width: 100%;
  padding: 12px;
  background: transparent;
  color: var(--color-text-secondary, #B8C2CC);
  border: none;
  font-size: 14px;
  cursor: pointer;
  margin-top: 8px;
  transition: color var(--motion-fast, 150ms);
}
.pro-restore:hover { color: var(--color-text-primary, #F8FAFC); }
.pro-legal {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-top: 24px;
  font-size: var(--size-caption, 12px);
}
.pro-legal-link {
  color: var(--color-text-muted, #7F8A96);
  text-decoration: none;
  transition: color var(--motion-fast, 150ms);
}
.pro-legal-link:hover { color: var(--color-text-primary, #F8FAFC); }
.pro-legal-sep { color: var(--color-text-muted, #7F8A96); }
</style>
