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

      <!-- 套餐展示（只读） -->
      <div class="plans-readonly">
        <div class="plan-card">
          <span class="plan-label">Monthly</span>
          <span class="plan-price">$2.99</span>
          <span class="plan-period">/ month</span>
        </div>
        <div class="plan-card featured">
          <span class="plan-label">Yearly</span>
          <span class="plan-badge">Best value</span>
          <span class="plan-price">$19.99</span>
          <span class="plan-period">/ year</span>
          <span class="plan-trial">7-day free trial</span>
        </div>
      </div>

      <!-- Coming soon CTA -->
      <button class="pro-cta" disabled @click="onCtaClick">
        Coming soon
      </button>
      <p class="pro-cta-sub">
        The core tuner is free to use. Pro features are coming soon.
      </p>

      <div class="pro-legal">
        <router-link to="/privacy" class="pro-legal-link">Privacy</router-link>
        <span class="pro-legal-sep">·</span>
        <router-link to="/support" class="pro-legal-link">Support</router-link>
      </div>
    </div>

    <ToastMessage ref="toastRef" />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import ProFeatureList from '../components/ProFeatureList.vue'
import ToastMessage from '../components/ToastMessage.vue'

const toastRef = ref<InstanceType<typeof ToastMessage>>()

const proFeatures = [
  'Custom tunings',
  'Alternate & drop tunings',
  'More instruments and tools',
  'Practice history',
  'Ad-free experience',
]

function onCtaClick() {
  toastRef.value?.show('Tuner Pro is coming soon. The core tuner is free to use.', 'info')
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

.plans-readonly {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 24px;
}
.plan-card {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  padding: 16px;
  background: var(--color-surface, #18212C);
  border: 2px solid var(--color-border, #314050);
  border-radius: var(--radius-md, 16px);
  opacity: 0.6;
}
.plan-card.featured {
  border-color: var(--color-accent, #E7B65C);
  background: rgba(231, 182, 92, 0.08);
  opacity: 1;
}
.plan-label { font-weight: 600; font-size: var(--size-body, 15px); }
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
.plan-price { font-weight: 600; font-size: var(--size-body-large, 17px); }
.plan-period { color: var(--color-text-muted, #7F8A96); font-size: var(--size-caption, 12px); }
.plan-trial {
  width: 100%;
  font-size: var(--size-caption, 12px);
  color: var(--color-success, #63C79A);
  margin-top: 4px;
}

.pro-cta {
  display: block;
  width: 100%;
  padding: 16px;
  background: var(--color-text-muted, #7F8A96);
  color: var(--color-canvas, #10151D);
  border: none;
  border-radius: var(--radius-sm, 10px);
  font-size: 17px;
  font-weight: 700;
  cursor: not-allowed;
  margin-top: 24px;
}
.pro-cta-sub {
  font-size: var(--size-caption, 12px);
  color: var(--color-text-muted, #7F8A96);
  text-align: center;
  margin: 12px 0 0;
}
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
