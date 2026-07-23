<template>
  <div class="plan-selector" role="radiogroup" aria-label="Subscription plan">
    <button
      v-for="plan in plans"
      :key="plan.id"
      :class="['plan-option', { active: modelValue === plan.id }]"
      role="radio"
      :aria-checked="modelValue === plan.id"
      @click="$emit('update:modelValue', plan.id)"
    >
      <span class="plan-label">{{ planLabel(plan) }}</span>
      <span v-if="plan.badge" class="plan-badge">{{ plan.badge }}</span>
      <span class="plan-price">{{ formattedPrice(plan) }}</span>
      <span v-if="plan.period !== 'lifetime'" class="plan-period">/ {{ plan.period }}</span>
      <span v-if="plan.trialDays" class="plan-trial">
        {{ plan.trialDays }}-day free trial
      </span>
    </button>
  </div>
</template>

<script setup lang="ts">
import type { SubscriptionPlan } from '../types/growth'

defineProps<{
  plans: SubscriptionPlan[]
  modelValue: SubscriptionPlan['id']
}>()

defineEmits<{
  'update:modelValue': [id: SubscriptionPlan['id']]
}>()

function planLabel(plan: SubscriptionPlan): string {
  const labels: Record<string, string> = { monthly: 'Monthly', yearly: 'Yearly', lifetime: 'Lifetime' }
  return labels[plan.id] || plan.id
}

function formattedPrice(plan: SubscriptionPlan): string {
  try {
    return new Intl.NumberFormat('en-US', { style: 'currency', currency: plan.currency }).format(plan.price)
  } catch {
    return `$${plan.price.toFixed(2)}`
  }
}
</script>

<style scoped>
.plan-selector {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.plan-option {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  padding: 16px;
  background: var(--color-surface, #18212C);
  border: 2px solid var(--color-border, #314050);
  border-radius: var(--radius-md, 16px);
  cursor: pointer;
  transition: all var(--motion-fast, 150ms) var(--motion-easing);
  text-align: left;
  width: 100%;
  color: var(--color-text-primary, #F8FAFC);
  font-size: var(--size-body, 15px);
}
.plan-option:hover { border-color: var(--color-border-strong, #4A5D70); }
.plan-option.active {
  border-color: var(--color-accent, #E7B65C);
  background: rgba(231, 182, 92, 0.08);
}
.plan-label { font-weight: 600; }
.plan-badge {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.5px;
  color: var(--color-ink, #1A222C);
  background: var(--color-accent, #E7B65C);
  padding: 2px 8px;
  border-radius: var(--radius-sm, 10px);
  text-transform: uppercase;
}
.plan-price { font-weight: 600; }
.plan-period { color: var(--color-text-muted, #7F8A96); font-size: var(--size-caption, 12px); }
.plan-trial {
  width: 100%;
  font-size: var(--size-caption, 12px);
  color: var(--color-success, #63C79A);
  margin-top: 4px;
}
</style>
