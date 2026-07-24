<template>
  <div class="tuner-page">
    <!-- 顶部栏 -->
    <header class="top-bar">
      <button class="back-btn" @click="$router.back()">‹</button>
      <div class="top-actions">
        <button class="action-btn" @click="showHelp = true">Help</button>
        <button class="action-btn" @click="showSettings = true">Settings</button>
      </div>
    </header>

    <!-- 麦克风错误卡片 -->
    <div v-if="micError" class="mic-error-card">
      <h3 class="mic-error-title">Microphone access is needed</h3>
      <p class="mic-error-desc">
        Allow microphone access to tune your instrument. Audio stays on this device.
      </p>
      <button class="mic-error-btn" @click="onTryAgain">Try again</button>
    </div>

    <!-- 横向调音仪表 -->
    <TuningMeter v-else :cents="currentCents" />

    <!-- 当前弦信息 -->
    <div class="string-info">
      <span class="string-note">{{ currentNoteLabel }}</span>
      <span class="string-freq">{{ currentFreqLabel }} Hz</span>
      <span class="string-name">{{ activePeg }}弦</span>
    </div>

    <!-- 吉他琴头 -->
    <HeadstockGuitar
      :active-peg="activePeg"
      :string-notes="stringNotes"
      @select="onSelectPeg"
      @change-note="onChangeNote"
    />

    <!-- 音名选择弹窗 -->
    <div v-if="pickerPeg" class="picker-overlay" @click="pickerPeg = 0">
      <div class="picker-popup" @click.stop>
        <div class="picker-title">String {{ pickerPeg }} tuning</div>
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
        <input type="checkbox" v-model="autoMode" @change="onAutoModeChange" />
        <span class="toggle-slider"></span>
      </label>
      <span class="toggle-label">Auto</span>
    </div>

    <!-- 调音状态提示 -->
    <div v-if="isListening && pitchData.frequency" class="tune-status" :class="statusClass">
      <span v-if="isInTune">In tune</span>
      <span v-else-if="currentCents > 0">Too high — loosen</span>
      <span v-else>Too low — tighten</span>
    </div>

    <!-- 帮助弹窗 -->
    <div v-if="showHelp" class="modal-overlay" @click="showHelp = false">
      <div class="modal-content" @click.stop>
        <h3>Tuning help</h3>
        <p>1. Tap a number to select a string</p>
        <p>2. Tap the note name to change the pitch</p>
        <p>3. Pluck the string and watch the meter</p>
        <button @click="showHelp = false">Got it</button>
      </div>
    </div>

    <!-- 设置弹窗 -->
    <div v-if="showSettings" class="modal-overlay" @click="showSettings = false">
      <div class="modal-content" @click.stop>
        <h3>Settings</h3>
        <div class="setting-row">
          <span>A4 reference</span>
          <select v-model.number="a4Ref" @change="onA4Change">
            <option :value="440">440 Hz</option>
            <option :value="442">442 Hz</option>
            <option :value="443">443 Hz</option>
          </select>
        </div>
        <div class="setting-row">
          <span>Voice feedback</span>
          <label class="toggle-switch">
            <input type="checkbox" :checked="voiceEnabled" @change="onVoiceChange" />
            <span class="toggle-slider"></span>
          </label>
        </div>
        <button @click="showSettings = false">Close</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { onBeforeRouteLeave } from 'vue-router'
import TuningMeter from '../components/TuningMeter.vue'
import HeadstockGuitar from '../components/HeadstockGuitar.vue'
import NotePicker from '../components/NotePicker.vue'
import { usePitchDetector } from '../composables/usePitchDetector'
import { useLocalPreferences } from '../composables/useLocalPreferences'

const allNotes: string[] = []
const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
for (let oct = 2; oct <= 4; oct++) {
  for (const n of noteNames) allNotes.push(`${n}${oct}`)
}

function noteToFreq(note: string): number {
  const match = note.match(/^([A-G]#?)(\d)$/)
  if (!match) return 440
  const semitoneMap: Record<string, number> = {
    'C': -9, 'C#': -8, 'D': -7, 'D#': -6, 'E': -5,
    'F': -4, 'F#': -3, 'G': -2, 'G#': -1, 'A': 0, 'A#': 1, 'B': 2,
  }
  const semitones = (parseInt(match[2]) - 4) * 12 + (semitoneMap[match[1]] ?? 0)
  return a4Ref.value * Math.pow(2, semitones / 12)
}

const strings = ref([
  { note: 'E4' }, { note: 'B3' }, { note: 'G3' },
  { note: 'D3' }, { note: 'A2' }, { note: 'E2' },
])

const stringNotes = computed(() => strings.value.map(s => s.note))
const selectedIdx = ref(0)
const pickerPeg = ref(0)
const showHelp = ref(false)
const showSettings = ref(false)

// 本地偏好
const { preferences, updatePreferences } = useLocalPreferences()
const a4Ref = ref(preferences.value.a4Reference)
const autoMode = ref(preferences.value.autoSelectString)

const { isListening, pitchData, micError, start, stop, setInstrument, toggleVoice, voiceEnabled, requestMicPermission } = usePitchDetector()
setInstrument('guitar')

// 从本地偏好初始化语音
onMounted(() => {
  toggleVoice(preferences.value.voiceEnabled)
  if (autoMode.value) start()
})

// 保存偏好变化
watch(a4Ref, (v) => updatePreferences({ a4Reference: v as 440 | 442 | 443 }))
watch(voiceEnabled, (v) => updatePreferences({ voiceEnabled: v }))

const activePeg = computed(() => selectedIdx.value + 1)
const currentString = computed(() => strings.value[selectedIdx.value])
const currentNoteLabel = computed(() => currentString.value?.note || '--')
const currentFreqLabel = computed(() => currentString.value ? noteToFreq(currentString.value.note).toFixed(1) : '--')

const currentCents = computed(() => {
  if (!pitchData.value.frequency || !currentString.value) return 0
  return Math.round(1200 * Math.log2(pitchData.value.frequency / noteToFreq(currentString.value.note)))
})
const isInTune = computed(() => Math.abs(currentCents.value) <= 5)
const statusClass = computed(() => isInTune.value ? 'in-tune' : 'off-tune')

function onAutoModeChange() {
  updatePreferences({ autoSelectString: autoMode.value })
  if (autoMode.value && !isListening.value) start()
}

function onA4Change() {
  updatePreferences({ a4Reference: a4Ref.value as 440 | 442 | 443 })
}

function onVoiceChange(e: Event) {
  const val = (e.target as HTMLInputElement).checked
  toggleVoice(val)
}

async function onTryAgain() {
  const ok = await requestMicPermission()
  if (ok) {
    start()
  } else {
    micError.value = 'denied'
  }
}

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

// 音准后自动跳下一弦
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

// 离开页面释放麦克风
onBeforeRouteLeave(() => {
  stop()
})
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
  display: flex; align-items: center; justify-content: space-between;
  padding: 12px 16px; width: 100%;
}
.back-btn {
  width: 36px; height: 36px;
  border: none; background: none;
  font-size: 24px; color: #fff; cursor: pointer;
}
.top-actions { display: flex; gap: 16px; }
.action-btn {
  background: none; border: none;
  color: #ccc; font-size: 14px; cursor: pointer;
}

/* 麦克风错误卡片 */
.mic-error-card {
  background: #1a1a2e;
  border: 1.5px solid #314050;
  border-radius: 16px;
  padding: 24px 20px;
  margin: 16px;
  text-align: center;
  max-width: 360px;
}
.mic-error-title {
  font-size: 17px; font-weight: 600; margin: 0 0 12px; color: #F8FAFC;
}
.mic-error-desc {
  font-size: 15px; color: #B8C2CC; margin: 0 0 20px; line-height: 1.45;
}
.mic-error-btn {
  padding: 12px 32px;
  background: #E7B65C; color: #1A222C;
  border: none; border-radius: 10px;
  font-size: 15px; font-weight: 600; cursor: pointer;
  transition: background 150ms;
}
.mic-error-btn:hover { background: #C98B32; }

.string-info {
  text-align: center; padding: 8px 0 4px;
}
.string-note {
  font-size: 32px; font-weight: 700; color: #fff; margin-right: 12px;
}
.string-freq { font-size: 16px; color: #888; margin-right: 8px; }
.string-name { font-size: 14px; color: #666; }

.picker-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex; align-items: center; justify-content: center;
  z-index: 100;
}
.picker-popup {
  background: #1a1a1a; border-radius: 16px; padding: 20px;
  width: 160px; border: 1px solid #333;
}
.picker-title {
  text-align: center; font-size: 16px; font-weight: 600;
  color: #fff; margin-bottom: 12px;
}

.auto-toggle {
  position: fixed; bottom: 24px; right: 24px;
  display: flex; align-items: center; gap: 8px; z-index: 10;
}
.toggle-switch {
  position: relative; width: 48px; height: 28px; cursor: pointer;
}
.toggle-switch input { opacity: 0; width: 0; height: 0; }
.toggle-slider {
  position: absolute; inset: 0;
  background: #555; border-radius: 14px; transition: 0.3s;
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
  text-align: center; padding: 12px;
  font-size: 16px; font-weight: 600;
}
.tune-status.in-tune { color: #4ade80; }
.tune-status.off-tune { color: #f87171; }

.modal-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex; align-items: center; justify-content: center;
  z-index: 100;
}
.modal-content {
  background: #222; border-radius: 16px;
  padding: 24px; max-width: 320px; width: 90%; color: #fff;
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
