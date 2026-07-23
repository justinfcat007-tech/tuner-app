<template>
  <button
    :class="['tuning-card', { locked }]"
    @click="locked ? $emit('locked') : $emit('select', preset.id)"
    :aria-label="preset.name + (locked ? ' — Pro' : '')"
  >
    <div class="tuning-card-name">{{ preset.name }}</div>
    <div class="tuning-card-notes">{{ preset.notes.join(' ') }}</div>
    <span v-if="locked" class="tuning-card-pro">PRO</span>
  </button>
</template>

<script setup lang="ts">
export interface TuningPreset {
  id: string
  name: string
  notes: string[]
  instrument: string
  locked?: boolean
}
defineProps<{
  preset: TuningPreset
  locked: boolean
}>()
defineEmits<{ select: [id: string]; locked: [] }>()
</script>

<style scoped>
.tuning-card {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  padding: 14px 16px;
  background: var(--color-surface, #18212C);
  border: 1.5px solid var(--color-border, #314050);
  border-radius: var(--radius-sm, 10px);
  cursor: pointer;
  transition: all var(--motion-fast, 150ms) var(--motion-easing);
  text-align: left;
  width: 100%;
  position: relative;
}
.tuning-card:hover { border-color: var(--color-border-strong, #4A5D70); }
.tuning-card.locked { opacity: 0.75; }
.tuning-card-name {
  font-size: var(--size-body, 15px);
  font-weight: 600;
  color: var(--color-text-primary, #F8FAFC);
  margin-bottom: 4px;
}
.tuning-card-notes {
  font-size: var(--size-caption, 12px);
  color: var(--color-text-muted, #7F8A96);
  letter-spacing: 0.5px;
}
.tuning-card-pro {
  position: absolute;
  top: 10px;
  right: 12px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1px;
  color: var(--color-accent, #E7B65C);
  border: 1px solid var(--color-accent, #E7B65C);
  padding: 2px 6px;
  border-radius: 4px;
}
</style>
