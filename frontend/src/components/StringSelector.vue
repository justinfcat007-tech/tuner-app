<template>
  <div class="string-selector">
    <h3 class="section-title">{{ instrument.name }} 弦位选择</h3>
    <div class="strings-grid" :class="{ 'yangqin-grid': instrument.id === 'yangqin' }">
      <button
        v-for="(str, index) in instrument.strings"
        :key="index"
        :class="['string-btn', { active: selectedIndex === index }]"
        @click="$emit('select', index)"
      >
        <span class="string-name">{{ str.name }}</span>
        <span class="string-note">{{ str.note }}</span>
        <span class="string-freq">{{ str.frequency.toFixed(1) }}Hz</span>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Instrument } from '../data/tunings'

defineProps<{
  instrument: Instrument
  selectedIndex: number | null
}>()

defineEmits<{
  select: [index: number]
}>()
</script>

<style scoped>
.string-selector {
  width: 100%;
  max-width: 800px;
  margin: 20px auto;
}

.section-title {
  color: #94a3b8;
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 12px;
  text-align: center;
}

.strings-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 8px;
}

.yangqin-grid {
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
}

.string-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 12px 8px;
  background: #1e293b;
  border: 2px solid #334155;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
}

.string-btn:hover {
  border-color: #64748b;
  background: #334155;
}

.string-btn.active {
  border-color: #3b82f6;
  background: #1e3a8a;
  box-shadow: 0 0 20px rgba(59, 130, 246, 0.3);
}

.string-name {
  font-size: 11px;
  color: #94a3b8;
  margin-bottom: 4px;
}

.string-note {
  font-size: 18px;
  font-weight: 700;
  color: #f1f5f9;
}

.string-freq {
  font-size: 11px;
  color: #64748b;
  margin-top: 2px;
}
</style>
