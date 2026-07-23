<template>
  <div class="tuner-home">
    <!-- Header -->
    <header class="home-header">
      <h1 class="home-brand">TUNER</h1>
      <ProBadge compact />
    </header>

    <p class="home-tagline">Tune with confidence, anywhere.</p>

    <!-- Instrument cards -->
    <div class="instrument-cards">
      <router-link to="/guitar" class="inst-card" @click="onInstrumentSelect('guitar')">
        <div class="inst-info">
          <span class="inst-name">Guitar</span>
          <span class="inst-tuning">Standard tuning</span>
        </div>
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M9 18l6-6-6-6"/>
        </svg>
      </router-link>
      <router-link to="/ukulele" class="inst-card" @click="onInstrumentSelect('ukulele')">
        <div class="inst-info">
          <span class="inst-name">Ukulele</span>
          <span class="inst-tuning">G – C – E – A</span>
        </div>
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M9 18l6-6-6-6"/>
        </svg>
      </router-link>
      <router-link to="/yangqin" class="inst-card" @click="onInstrumentSelect('yangqin')">
        <div class="inst-info">
          <span class="inst-name">Yangqin</span>
          <span class="inst-tuning">Explore</span>
        </div>
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M9 18l6-6-6-6"/>
        </svg>
      </router-link>
    </div>

    <!-- Pro entry card (free users only) -->
    <div class="pro-entry-card" @click="$router.push('/pro')">
      <p class="pro-entry-text">
        More instruments &amp; custom tunings are available in Pro.
      </p>
      <span class="pro-entry-cta">Explore Pro</span>
    </div>

    <!-- Tuning Library entry -->
    <router-link to="/tuning-library" class="lib-entry">
      <span>More tunings</span>
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M9 18l6-6-6-6"/>
      </svg>
    </router-link>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import ProBadge from '../components/ProBadge.vue'
import { track } from '../utils/analytics'

function onInstrumentSelect(instrument: string) {
  track('pro_entry_viewed', { source: `home_${instrument}` })
}

onMounted(() => {
  track('pro_entry_viewed', { source: 'home' })
})
</script>

<style scoped>
.tuner-home {
  background: var(--color-canvas, #10151D);
  min-height: 100vh;
  color: var(--color-text-primary, #F8FAFC);
  max-width: 480px;
  margin: 0 auto;
  padding: 16px;
}
.home-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}
.home-brand {
  font-family: var(--font-display, Georgia);
  font-size: var(--size-title, 24px);
  font-weight: 700;
  margin: 0;
  letter-spacing: 2px;
}
.home-tagline {
  font-size: var(--size-body, 15px);
  color: var(--color-text-secondary, #B8C2CC);
  margin: 0 0 24px;
}
.instrument-cards {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 24px;
}
.inst-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 20px;
  background: var(--color-surface, #18212C);
  border: 1.5px solid var(--color-border, #314050);
  border-radius: var(--radius-md, 16px);
  text-decoration: none;
  color: var(--color-text-primary, #F8FAFC);
  transition: all var(--motion-fast, 150ms) var(--motion-easing);
}
.inst-card:hover {
  border-color: var(--color-border-strong, #4A5D70);
  background: var(--color-surface-raised, #202C39);
}
.inst-info { display: flex; flex-direction: column; gap: 2px; }
.inst-name { font-size: var(--size-body-large, 17px); font-weight: 600; }
.inst-tuning { font-size: var(--size-caption, 12px); color: var(--color-text-muted, #7F8A96); }

.pro-entry-card {
  background: var(--color-surface-warm, #F7F0E3);
  border-radius: var(--radius-md, 16px);
  padding: 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  transition: transform var(--motion-fast, 150ms);
  margin-bottom: 16px;
}
.pro-entry-card:hover { transform: translateY(-1px); }
.pro-entry-text {
  font-size: var(--size-body, 15px);
  color: var(--color-ink, #1A222C);
  margin: 0;
  line-height: var(--lh-normal, 1.45);
}
.pro-entry-cta {
  font-size: var(--size-body, 15px);
  font-weight: 700;
  color: var(--color-accent-strong, #C98B32);
  white-space: nowrap;
}

.lib-entry {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 20px;
  background: var(--color-surface, #18212C);
  border: 1.5px solid var(--color-border, #314050);
  border-radius: var(--radius-sm, 10px);
  text-decoration: none;
  color: var(--color-text-secondary, #B8C2CC);
  font-size: var(--size-body, 15px);
  transition: all var(--motion-fast, 150ms);
}
.lib-entry:hover {
  border-color: var(--color-border-strong, #4A5D70);
  color: var(--color-text-primary, #F8FAFC);
}
</style>
