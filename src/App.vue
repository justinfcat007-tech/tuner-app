<template>
  <div class="app">
    <!-- Header -->
    <header class="header">
      <h1 class="title">🎶 调音器</h1>
      <p class="subtitle">Tuner — 扬琴 · 吉他 · 尤克里里</p>
    </header>

    <!-- Instrument selector -->
    <div class="instrument-tabs">
      <button
        v-for="inst in instruments"
        :key="inst.id"
        :class="['tab-btn', { active: currentInstrument.id === inst.id }]"
        @click="selectInstrument(inst)"
      >
        <span class="tab-emoji">{{ inst.emoji }}</span>
        <span class="tab-name">{{ inst.name }}</span>
        <span class="tab-name-en">{{ inst.nameEn }}</span>
      </button>
    </div>

    <!-- Tuner gauge -->
    <TunerGauge
      :note="pitchData.note"
      :frequency="pitchData.frequency"
      :cents="pitchData.cents"
      :in-tune="pitchData.inTune"
    />

    <!-- Target string info -->
    <div v-if="targetString" class="target-info" :class="{ 'match': isMatch }">
      <div class="target-label">目标弦</div>
      <div class="target-note">{{ targetString!.note }}</div>
      <div class="target-freq">{{ targetString!.frequency.toFixed(1) }} Hz</div>
      <div class="target-name">{{ targetString!.name }}</div>
      <div v-if="isMatch" class="match-indicator">
        <span v-if="pitchData.inTune">✅ 已准</span>
        <span v-else-if="pitchData.cents > 0">偏高 ↓ 松弦</span>
        <span v-else-if="pitchData.cents < 0">偏低 ↑ 紧弦</span>
      </div>
    </div>

    <!-- Mic control -->
    <div class="controls">
      <button :class="['mic-btn', { listening: isListening }]" @click="toggleMic">
        <span class="mic-icon">{{ isListening ? '🎙️' : '🔇' }}</span>
        <span>{{ isListening ? '正在监听...' : '点击开始' }}</span>
      </button>
      <div v-if="isListening" class="volume-bar">
        <div class="volume-fill" :style="{ width: (volume * 100) + '%' }"></div>
      </div>
    </div>

    <!-- String selector -->
    <StringSelector
      :instrument="currentInstrument"
      :selected-index="selectedStringIndex"
      @select="selectedStringIndex = $event"
    />

    <!-- Footer -->
    <footer class="footer">
      <p>基于 Web Audio API · 自动检测音高 · 支持标准调弦</p>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import TunerGauge from './components/TunerGauge.vue'
import StringSelector from './components/StringSelector.vue'
import { instruments, type Instrument } from './data/tunings'
import { usePitchDetector } from './composables/usePitchDetector'

const currentInstrument = ref(instruments[1]) // default guitar
const selectedStringIndex = ref<number | null>(null)

const { isListening, pitchData, volume, start, stop } = usePitchDetector()

function selectInstrument(inst: Instrument) {
  currentInstrument.value = inst
  selectedStringIndex.value = null
}

function toggleMic() {
  if (isListening.value) stop()
  else start()
}

const targetString = computed(() => {
  if (selectedStringIndex.value === null) return null
  return currentInstrument.value.strings[selectedStringIndex.value]
})

const isMatch = computed(() => {
  if (!targetString.value || !pitchData.value.note) return false
  return pitchData.value.note === targetString.value.note
})
</script>

<style scoped>
.app {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
  min-height: 100vh;
}

.header {
  text-align: center;
  margin-bottom: 24px;
}

.title {
  font-size: 32px;
  font-weight: 700;
  color: #f1f5f9;
  margin: 0;
}

.subtitle {
  color: #64748b;
  font-size: 14px;
  margin-top: 4px;
}

/* Instrument tabs */
.instrument-tabs {
  display: flex;
  gap: 10px;
  justify-content: center;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.tab-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 12px 24px;
  background: #1e293b;
  border: 2px solid #334155;
  border-radius: 16px;
  cursor: pointer;
  transition: all 0.25s;
  min-width: 120px;
}

.tab-btn:hover {
  border-color: #64748b;
  transform: translateY(-2px);
}

.tab-btn.active {
  border-color: #3b82f6;
  background: #1e3a8a;
  box-shadow: 0 4px 20px rgba(59, 130, 246, 0.3);
}

.tab-emoji {
  font-size: 28px;
  margin-bottom: 4px;
}

.tab-name {
  font-size: 16px;
  font-weight: 600;
  color: #f1f5f9;
}

.tab-name-en {
  font-size: 11px;
  color: #64748b;
}

/* Target info */
.target-info {
  text-align: center;
  padding: 16px;
  background: #1e293b;
  border-radius: 16px;
  border: 2px solid #334155;
  margin: 16px auto;
  max-width: 300px;
  transition: all 0.3s;
}

.target-info.match {
  border-color: #22c55e;
  background: #14532d;
}

.target-label {
  font-size: 12px;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.target-note {
  font-size: 36px;
  font-weight: 700;
  color: #f1f5f9;
}

.target-freq {
  font-size: 14px;
  color: #94a3b8;
}

.target-name {
  font-size: 12px;
  color: #64748b;
  margin-top: 4px;
}

.match-indicator {
  margin-top: 8px;
  font-size: 16px;
  font-weight: 600;
}

/* Mic control */
.controls {
  text-align: center;
  margin: 24px 0;
}

.mic-btn {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 14px 32px;
  font-size: 16px;
  font-weight: 600;
  color: #f1f5f9;
  background: #334155;
  border: 2px solid #475569;
  border-radius: 50px;
  cursor: pointer;
  transition: all 0.3s;
}

.mic-btn:hover {
  background: #475569;
  transform: scale(1.05);
}

.mic-btn.listening {
  background: #991b1b;
  border-color: #ef4444;
  animation: pulse 2s infinite;
}

.mic-icon {
  font-size: 22px;
}

@keyframes pulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.4); }
  50% { box-shadow: 0 0 0 12px rgba(239, 68, 68, 0); }
}

.volume-bar {
  width: 200px;
  height: 4px;
  background: #334155;
  border-radius: 2px;
  margin: 12px auto;
  overflow: hidden;
}

.volume-fill {
  height: 100%;
  background: linear-gradient(90deg, #22c55e, #eab308, #ef4444);
  border-radius: 2px;
  transition: width 0.05s;
}

/* Footer */
.footer {
  text-align: center;
  margin-top: 40px;
  padding: 20px;
  color: #475569;
  font-size: 12px;
}
</style>
