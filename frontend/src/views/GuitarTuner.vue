<template>
  <div class="tuner-page">
    <!-- 顶部栏 -->
    <header class="top-bar">
      <button class="back-btn" @click="$router.back()">‹</button>
      <div class="top-actions">
        <button class="action-btn" @click="showHelp = true">▶ 调音帮助</button>
        <button class="action-btn" @click="showSettings = true">⚙ 调音设置</button>
      </div>
    </header>

    <!-- 横向调音仪表 -->
    <TuningMeter :cents="currentCents" />

    <!-- 当前弦信息 -->
    <div class="string-info">
      <span class="string-note">{{ currentNoteLabel }}</span>
      <span class="string-freq">{{ currentFreqLabel }} Hz</span>
      <span class="string-name">{{ activePeg }}弦</span>
    </div>

    <!-- 吉他琴头 + 编号/音名 -->
    <HeadstockGuitar
      :active-peg="activePeg"
      :string-notes="stringNotes"
      @select="onSelectPeg"
      @change-note="onChangeNote"
    />

    <!-- 音名选择弹窗 -->
    <div v-if="pickerPeg" class="picker-overlay" @click="pickerPeg = 0">
      <div class="picker-popup" @click.stop>
        <div class="picker-title">{{ pickerPeg }}弦 调音</div>
        <NotePicker
          :notes="allNotes"
          :model-value="strings[pickerPeg - 1]?.note || 'E2'"
          @update:model-value="onPickerChange"
        />
      </div>
    </div>

    <!-- 自动模式开关 -->
    <div class="auto-toggle">
      <label class="toggle-switch">
        <input type="checkbox" v-model="autoMode" />
        <span class="toggle-slider"></span>
      </label>
      <span class="toggle-label">自动</span>
    </div>

    <!-- 调音状态提示 -->
    <div v-if="isListening && pitchData.frequency" class="tune-status" :class="statusClass">
      <span v-if="isInTune">✅ 已准</span>
      <span v-else-if="currentCents > 0">偏高 ↓ 松弦</span>
      <span v-else>偏低 ↑ 紧弦</span>
    </div>
    <div v-else-if="isListening" class="signal-status">
      {{ detectionState === 'waiting' ? '正在等待声音稳定…' : detectionState === 'unstable' ? '声音不稳定，请单独拨动一根弦' : '请拨动琴弦' }}
    </div>

    <!-- 帮助弹窗 -->
    <div v-if="showHelp" class="modal-overlay" @click="showHelp = false">
      <div class="modal-content" @click.stop>
        <h3>调音帮助</h3>
        <p>1. 点击编号选中要调的弦</p>
        <p>2. 点击音名更改该弦的音高</p>
        <p>3. 弹奏该弦，观察仪表</p>
        <button @click="showHelp = false">知道了</button>
      </div>
    </div>

    <!-- 设置弹窗 -->
    <div v-if="showSettings" class="modal-overlay" @click="showSettings = false">
      <div class="modal-content" @click.stop>
        <h3>调音设置</h3>
        <div class="setting-row">
          <span>标准音高</span>
          <select v-model="a4Ref">
            <option :value="440">440 Hz</option>
            <option :value="442">442 Hz</option>
            <option :value="443">443 Hz</option>
          </select>
        </div>
        <div class="setting-row">
          <span>语音提示</span>
          <label class="toggle-switch">
            <input type="checkbox" :checked="voiceEnabled" @change="toggleVoice(($event.target as HTMLInputElement).checked)" />
            <span class="toggle-slider"></span>
          </label>
        </div>
        <button @click="showSettings = false">关闭</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onBeforeUnmount } from 'vue'
import TuningMeter from '../components/TuningMeter.vue'
import HeadstockGuitar from '../components/HeadstockGuitar.vue'
import NotePicker from '../components/NotePicker.vue'
import { usePitchDetector } from '../composables/usePitchDetector'

const allNotes: string[] = []
// 同时提供升、降号及少见的等音拼写，方便处理特殊/非标准调弦。
const noteNames = [
  'C', 'C#', 'Db', 'D', 'D#', 'Eb', 'E', 'E#', 'Fb', 'F', 'F#', 'Gb',
  'G', 'G#', 'Ab', 'A', 'A#', 'Bb', 'B', 'B#', 'Cb',
]
for (let oct = 2; oct <= 4; oct++) {
  for (const n of noteNames) allNotes.push(`${n}${oct}`)
}

function noteToFreq(note: string): number {
  const match = note.match(/^([A-G])([#b♯♭]?)(\d+)$/)
  if (!match) return 440
  const naturalSemitones: Record<string, number> = {
    C: -9, D: -7, E: -5, F: -4, G: -2, A: 0, B: 2,
  }
  const accidental = match[2]
  const accidentalOffset = accidental === '#' || accidental === '♯' ? 1 : accidental === 'b' || accidental === '♭' ? -1 : 0
  const semitones = (parseInt(match[3], 10) - 4) * 12 + (naturalSemitones[match[1]] ?? 0) + accidentalOffset
  return a4Ref.value * Math.pow(2, semitones / 12)
}

// strings[0]=1弦, strings[1]=2弦 ... strings[5]=6弦
const strings = ref([
  { note: 'E4' },  // 1弦
  { note: 'B3' },  // 2弦
  { note: 'G3' },  // 3弦
  { note: 'D3' },  // 4弦
  { note: 'A2' },  // 5弦
  { note: 'E2' },  // 6弦
])

const stringNotes = computed(() => strings.value.map(s => s.note))

const selectedIdx = ref(0)  // 0=1弦, 5=6弦
const pickerPeg = ref(0)    // 0=没有弹窗, 1-6=对应弦
const autoMode = ref(true)
const a4Ref = ref(440)
const showHelp = ref(false)
const showSettings = ref(false)

const { isListening, pitchData, detectionState, start, stop, setInstrument, setTargetFrequency, toggleVoice, voiceEnabled } = usePitchDetector()

// 初始化乐器类型
setInstrument('guitar')

const activePeg = computed(() => selectedIdx.value + 1)
const currentString = computed(() => strings.value[selectedIdx.value])
const currentNoteLabel = computed(() => currentString.value?.note || '--')
const currentFreqLabel = computed(() => currentString.value ? noteToFreq(currentString.value.note).toFixed(1) : '--')

watch([currentString, a4Ref], () => {
  if (currentString.value) setTargetFrequency(noteToFreq(currentString.value.note))
}, { immediate: true })

const currentCents = computed(() => {
  if (!pitchData.value.frequency || !currentString.value) return 0
  return Math.round(1200 * Math.log2(pitchData.value.frequency / noteToFreq(currentString.value.note)))
})
const isInTune = computed(() => Math.abs(currentCents.value) <= 5)
const statusClass = computed(() => isInTune.value ? 'in-tune' : 'off-tune')

function onSelectPeg(num: number) {
  selectedIdx.value = num - 1
  autoMode.value = false
}

function onChangeNote(num: number) {
  pickerPeg.value = num
  selectedIdx.value = num - 1
}

function onPickerChange(note: string) {
  if (pickerPeg.value > 0) {
    strings.value[pickerPeg.value - 1].note = note
  }
}

// 音准后自动跳下一弦 (6→5→4→3→2→1)
let advanceTimer: ReturnType<typeof setTimeout> | null = null
watch(isInTune, (tuned) => {
  if (!tuned || !pitchData.value.frequency) return
  if (advanceTimer) clearTimeout(advanceTimer)
  advanceTimer = setTimeout(() => {
    if (selectedIdx.value > 0) selectedIdx.value--
  }, 800)
})

watch(() => pitchData.value.frequency, (freq) => {
  if (!autoMode.value || !freq) return
  let bestIdx = 0, bestCents = Infinity
  strings.value.forEach((s, i) => {
    const c = Math.abs(1200 * Math.log2(freq / noteToFreq(s.note)))
    if (c < bestCents) { bestCents = c; bestIdx = i }
  })
  if (bestCents < 100) selectedIdx.value = bestIdx
})

if (autoMode.value) start()

onBeforeUnmount(stop)
</script>

<style scoped>
.tuner-page {
  background: #111;
  min-height: 100vh;
  color: #fff;
  padding-bottom: 60px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.top-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  width: 100%;
}
.back-btn {
  width: 36px; height: 36px;
  border: none; background: none;
  font-size: 24px; color: #fff;
  cursor: pointer;
}
.top-actions { display: flex; gap: 16px; }
.action-btn {
  background: none; border: none;
  color: #ccc; font-size: 14px;
  cursor: pointer;
}

.string-info {
  text-align: center;
  padding: 8px 0 4px;
}
.string-note {
  font-size: 32px;
  font-weight: 700;
  color: #fff;
  margin-right: 12px;
}
.string-freq {
  font-size: 16px;
  color: #888;
  margin-right: 8px;
}
.string-name {
  font-size: 14px;
  color: #666;
}

/* 音名选择弹窗 */
.picker-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}
.picker-popup {
  background: #1a1a1a;
  border-radius: 16px;
  padding: 20px;
  width: 160px;
  border: 1px solid #333;
}
.picker-title {
  text-align: center;
  font-size: 16px;
  font-weight: 600;
  color: #fff;
  margin-bottom: 12px;
}

.auto-toggle {
  position: fixed;
  bottom: 24px;
  right: 24px;
  display: flex;
  align-items: center;
  gap: 8px;
  z-index: 10;
}
.toggle-switch {
  position: relative;
  width: 48px; height: 28px;
  cursor: pointer;
}
.toggle-switch input { opacity: 0; width: 0; height: 0; }
.toggle-slider {
  position: absolute; inset: 0;
  background: #555; border-radius: 14px;
  transition: 0.3s;
}
.toggle-slider::before {
  content: '';
  position: absolute;
  width: 22px; height: 22px;
  left: 3px; top: 3px;
  background: #fff; border-radius: 50%;
  transition: 0.3s;
}
.toggle-switch input:checked + .toggle-slider { background: #a855f7; }
.toggle-switch input:checked + .toggle-slider::before { transform: translateX(20px); }
.toggle-label { color: #ccc; font-size: 14px; }

.tune-status {
  text-align: center;
  padding: 12px;
  font-size: 16px;
  font-weight: 600;
}
.tune-status.in-tune { color: #4ade80; }
.tune-status.off-tune { color: #f87171; }
.signal-status { min-height: 43px; padding: 12px; color: #9ca3af; font-size: 14px; }

.modal-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex; align-items: center; justify-content: center;
  z-index: 100;
}
.modal-content {
  background: #222; border-radius: 16px;
  padding: 24px; max-width: 320px; width: 90%;
  color: #fff;
}
.modal-content h3 { margin-bottom: 16px; font-size: 18px; }
.modal-content p { margin: 8px 0; font-size: 14px; color: #aaa; line-height: 1.6; }
.modal-content button {
  margin-top: 16px; width: 100%; padding: 12px;
  background: #a855f7; color: #fff; border: none;
  border-radius: 10px; font-size: 15px; cursor: pointer;
}
.setting-row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 12px 0; font-size: 14px; color: #aaa;
}
.setting-row select {
  background: #333; color: #fff;
  border: 1px solid #555; padding: 6px 12px;
  border-radius: 6px; font-size: 14px;
}
</style>
