<template>
  <div class="lib-page">
    <header class="lib-header">
      <button class="lib-back" @click="$router.back()" aria-label="Go back">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M15 18l-6-6 6-6"/>
        </svg>
      </button>
      <h1 class="lib-title">Tuning Library</h1>
    </header>

    <div class="lib-content">
      <div class="lib-section-header">
        <h2>My tunings</h2>
        <button class="lib-create" @click="onCreateCustom" aria-label="Create custom tuning">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 5v14M5 12h14"/>
          </svg>
          <span>Create</span>
          <span class="lib-pro-tag">PRO</span>
        </button>
      </div>

      <h3 class="lib-subtitle">Popular</h3>
      <div class="lib-grid">
        <TuningPresetCard
          v-for="preset in presets"
          :key="preset.id"
          :preset="preset"
          :locked="preset.locked ?? false"
          @select="onSelect"
          @locked="onLocked(preset.id)"
        />
      </div>

      <h3 class="lib-subtitle">Explore instruments</h3>
      <div class="lib-instruments">
        <button v-for="inst in instruments" :key="inst" class="lib-inst-btn" @click="onLocked(inst)">
          {{ inst }}
          <span class="lib-pro-tag">PRO</span>
        </button>
      </div>
    </div>

    <FeatureGateSheet
      :feature="gateFeature"
      :open="gateOpen"
      source="tuning_library"
      @close="gateOpen = false"
      @explore="onGateExplore"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import TuningPresetCard from '../components/TuningPresetCard.vue'
import FeatureGateSheet from '../components/FeatureGateSheet.vue'
import type { ProFeature } from '../types/growth'
import type { TuningPreset } from '../components/TuningPresetCard.vue'

const router = useRouter()

// Standard tuning is free; others are Pro
const presets: TuningPreset[] = [
  { id: 'standard', name: 'Standard E', notes: ['E', 'A', 'D', 'G', 'B', 'E'], instrument: 'guitar', locked: false },
  { id: 'drop-d', name: 'Drop D', notes: ['D', 'A', 'D', 'G', 'B', 'E'], instrument: 'guitar', locked: true },
  { id: 'dadgad', name: 'DADGAD', notes: ['D', 'A', 'D', 'G', 'A', 'D'], instrument: 'guitar', locked: true },
  { id: 'open-g', name: 'Open G', notes: ['D', 'G', 'D', 'G', 'B', 'D'], instrument: 'guitar', locked: true },
  { id: 'half-down', name: 'Half Step Down', notes: ['Eb', 'Ab', 'Db', 'Gb', 'Bb', 'Eb'], instrument: 'guitar', locked: true },
]

const instruments = ['Bass', 'Mandolin', 'Banjo']
const gateOpen = ref(false)
const gateFeature = ref<ProFeature>('custom-tunings')

function onGateExplore() {
  gateOpen.value = false
  router.push('/pro')
}

function onSelect(id: string) {
  // Standard tuning is free — apply directly
  console.log('Selected tuning:', id)
}

function onLocked(id: string) {
  gateFeature.value = id === 'Bass' || id === 'Mandolin' || id === 'Banjo'
    ? 'instrument-library' : 'alternate-tunings'
  gateOpen.value = true
}

function onCreateCustom() {
  gateFeature.value = 'custom-tunings'
  gateOpen.value = true
}
</script>

<style scoped>
.lib-page {
  background: var(--color-canvas, #10151D);
  min-height: 100vh;
  color: var(--color-text-primary, #F8FAFC);
  max-width: 480px;
  margin: 0 auto;
}
.lib-header {
  display: flex; align-items: center; gap: 16px;
  padding: 16px;
}
.lib-back {
  width: 44px; height: 44px;
  background: none; border: none;
  color: var(--color-text-primary, #F8FAFC);
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  border-radius: 50%;
  transition: background var(--motion-fast, 150ms);
}
.lib-back:hover { background: rgba(255,255,255,0.08); }
.lib-title {
  font-family: var(--font-display, Georgia);
  font-size: var(--size-title, 24px);
  font-weight: 700;
  margin: 0;
}
.lib-content { padding: 0 16px 48px; }
.lib-section-header {
  display: flex; justify-content: space-between; align-items: center;
  margin-bottom: 16px;
}
.lib-section-header h2 {
  font-size: var(--size-body-large, 17px); font-weight: 600; margin: 0;
}
.lib-create {
  display: flex; align-items: center; gap: 6px;
  background: none; border: 1.5px solid var(--color-border, #314050);
  color: var(--color-accent, #E7B65C);
  padding: 8px 14px; border-radius: var(--radius-sm, 10px);
  font-size: 13px; font-weight: 600; cursor: pointer;
  transition: all var(--motion-fast, 150ms);
}
.lib-create:hover { border-color: var(--color-accent, #E7B65C); }
.lib-pro-tag {
  font-size: 10px; font-weight: 700; letter-spacing: 0.5px;
  color: var(--color-accent, #E7B65C);
}
.lib-subtitle {
  font-size: var(--size-caption, 12px);
  font-weight: 600;
  color: var(--color-text-muted, #7F8A96);
  text-transform: uppercase;
  letter-spacing: 1px;
  margin: 24px 0 12px;
}
.lib-grid {
  display: flex; flex-direction: column; gap: 10px;
}
.lib-instruments {
  display: flex; gap: 10px; flex-wrap: wrap;
}
.lib-inst-btn {
  display: flex; align-items: center; gap: 8px;
  padding: 12px 18px;
  background: var(--color-surface, #18212C);
  border: 1.5px solid var(--color-border, #314050);
  border-radius: var(--radius-sm, 10px);
  color: var(--color-text-primary, #F8FAFC);
  font-size: 14px; font-weight: 600;
  cursor: pointer;
  transition: all var(--motion-fast, 150ms);
}
.lib-inst-btn:hover { border-color: var(--color-border-strong, #4A5D70); }
</style>
