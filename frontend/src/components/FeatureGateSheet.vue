<template>
  <Teleport to="body">
    <Transition name="sheet">
      <div v-if="open" class="gate-overlay" @click="onClose" :aria-hidden="!open">
        <div class="gate-sheet" @click.stop role="dialog" aria-modal="true" ref="sheetRef">
          <button class="gate-close" @click="onClose" aria-label="Close">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          </button>

          <h3 class="gate-title">{{ title }}</h3>
          <p class="gate-desc">{{ description }}</p>

          <ProFeatureList :items="benefits" />

          <button class="gate-cta" @click="onExplore">
            See Tuner Pro
          </button>
          <button class="gate-dismiss" @click="onClose">
            Not now
          </button>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick } from 'vue'
import type { ProFeature } from '../types/growth'
import ProFeatureList from './ProFeatureList.vue'
import { track } from '../utils/analytics'

const props = defineProps<{
  feature: ProFeature
  open: boolean
  source?: string
}>()

const emit = defineEmits<{ close: []; explore: [] }>()

const sheetRef = ref<HTMLElement>()

// 根据 feature 替换文案
const featureContent: Record<ProFeature, { title: string; desc: string; benefits: string[] }> = {
  'custom-tunings': {
    title: 'Make every tuning yours',
    desc: 'Save alternate tunings and get back to them in one tap.',
    benefits: ['Unlimited custom tunings', 'Alternate & drop tunings', 'Ad-free practice tools'],
  },
  'alternate-tunings': {
    title: 'Unlock every tuning',
    desc: 'Explore drop tunings, open tunings, and more — all in one place.',
    benefits: ['Drop D, DADGAD, open G & more', 'Custom tuning editor', 'Ad-free experience'],
  },
  'instrument-library': {
    title: 'More instruments, more fun',
    desc: 'Access bass, mandolin, banjo and other instruments.',
    benefits: ['Bass, mandolin, banjo & more', 'Per-instrument tunings', 'Ad-free tools'],
  },
  'practice-history': {
    title: 'Track your progress',
    desc: 'Review every tuning session and see your improvement over time.',
    benefits: ['Session history & stats', 'Tuning accuracy trends', 'Export your data'],
  },
  'ad-free': {
    title: 'Practice without interruptions',
    desc: 'Remove all ads and enjoy a cleaner, focused experience.',
    benefits: ['No ads anywhere', 'All Pro features included', 'Priority support'],
  },
}

const content = computed(() => featureContent[props.feature] || featureContent['custom-tunings'])
const title = computed(() => content.value.title)
const description = computed(() => content.value.desc)
const benefits = computed(() => content.value.benefits)

function onClose() {
  emit('close')
  // 7 天内不再自动触发同一功能
  try {
    localStorage.setItem(`gate-${props.feature}`, String(Date.now()))
  } catch {}
}

function onExplore() {
  emit('explore')
}

watch(() => props.open, (val) => {
  if (val) {
    track('feature_gate_viewed', { feature: props.feature, source: props.source || '' })
    nextTick(() => sheetRef.value?.focus())
  }
})
</script>

<style scoped>
.gate-overlay {
  position: fixed;
  inset: 0;
  background: var(--color-overlay, rgba(5, 10, 16, 0.48));
  z-index: 150;
  display: flex;
  align-items: flex-end;
  justify-content: center;
}
.gate-sheet {
  background: var(--color-surface-raised, #202C39);
  border-radius: var(--radius-lg, 24px) var(--radius-lg, 24px) 0 0;
  padding: 32px 24px 40px;
  width: 100%;
  max-width: 480px;
  position: relative;
  outline: none;
  box-shadow: var(--shadow-sheet, 0 -12px 40px rgba(0,0,0,0.32));
}
.gate-close {
  position: absolute;
  top: 16px;
  right: 16px;
  background: none;
  border: none;
  color: var(--color-text-secondary, #B8C2CC);
  cursor: pointer;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background var(--motion-fast, 150ms);
}
.gate-close:hover { background: rgba(255,255,255,0.08); }
.gate-title {
  font-family: var(--font-display, Georgia);
  font-size: var(--size-title, 24px);
  font-weight: 700;
  color: var(--color-text-primary, #F8FAFC);
  margin: 0 0 12px;
}
.gate-desc {
  font-size: var(--size-body, 15px);
  color: var(--color-text-secondary, #B8C2CC);
  line-height: var(--lh-normal, 1.45);
  margin: 0 0 20px;
}
.gate-cta {
  display: block;
  width: 100%;
  padding: 14px;
  background: var(--color-accent, #E7B65C);
  color: var(--color-ink, #1A222C);
  border: none;
  border-radius: var(--radius-sm, 10px);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  margin-bottom: 12px;
  transition: background var(--motion-fast, 150ms);
}
.gate-cta:hover { background: var(--color-accent-strong, #C98B32); }
.gate-dismiss {
  display: block;
  width: 100%;
  padding: 12px;
  background: transparent;
  color: var(--color-text-secondary, #B8C2CC);
  border: none;
  font-size: 14px;
  cursor: pointer;
  transition: color var(--motion-fast, 150ms);
}
.gate-dismiss:hover { color: var(--color-text-primary, #F8FAFC); }

.sheet-enter-active, .sheet-leave-active {
  transition: opacity var(--motion-normal, 220ms) var(--motion-easing);
}
.sheet-enter-from, .sheet-leave-to { opacity: 0; }
</style>
