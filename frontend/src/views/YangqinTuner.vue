<template>
  <div class="yangqin-page">
    <!-- 顶部 -->
    <header class="top-bar">
      <button class="back-btn" @click="$router.back()">‹</button>
      <button class="help-btn" @click="showHelp = !showHelp">?</button>
    </header>

    <!-- 调音仪表盘 -->
    <TunerGauge :cents="currentCents" :in-tune="isInTune" :active="!!pitchData.frequency" />

    <!-- 音高信息面板 -->
    <div class="info-panel">
      <div class="info-row">
        <div class="info-item">
          <span class="info-label">正确音名</span>
          <span class="info-value correct">{{ targetNote }}</span>
        </div>
        <div class="info-item">
          <span class="info-label">当前音名</span>
          <span class="info-value" :class="currentNoteClass">{{ currentNote }}</span>
        </div>
      </div>
      <div class="info-row">
        <div class="info-item">
          <span class="info-label">正确频率</span>
          <span class="info-value correct">{{ targetFreq }}</span>
          <span class="info-unit">Hz</span>
        </div>
        <div class="info-item">
          <span class="info-label">当前频率</span>
          <span class="info-value" :class="currentNoteClass">{{ currentFreq }}</span>
          <span class="info-unit">Hz</span>
        </div>
      </div>
      <div class="info-row">
        <div class="info-item">
          <span class="info-label">简谱</span>
          <span class="info-value correct">{{ currentNotation }}</span>
        </div>
        <div class="info-item">
          <span class="info-label">音准</span>
          <span class="info-value" :class="tuneStatusClass">{{ tuneStatus }}</span>
        </div>
      </div>
    </div>

    <!-- 440/442 频率开关 -->
    <div class="a4-switch">
      <button :class="['a4-btn', { active: a4Ref === 440 }]" @click="a4Ref = 440">440</button>
      <button :class="['a4-btn', { active: a4Ref === 442 }]" @click="a4Ref = 442">442</button>
    </div>

    <!-- 列选择 -->
    <div class="selector-group">
      <div class="selector-label">列</div>
      <div class="selector-scroll">
        <button
          v-for="c in 6" :key="c"
          :class="['sel-btn', { active: selectedCol === c }]"
          @click="onColChange(c)"
        >{{ c }}</button>
      </div>
    </div>

    <!-- 弦列表 -->
    <div class="string-list">
      <div
        v-for="s in stringsInCol"
        :key="s.stringNum"
        :class="['string-row', { active: selectedStringNum === s.stringNum }]"
        @click="selectedStringNum = s.stringNum"
      >
        <span class="string-num">{{ s.stringNum }}弦</span>
        <span class="string-note">{{ s.label }}</span>
        <span class="string-notation">[{{ s.notation }}]</span>
      </div>
    </div>

    <!-- 麦克风控制 -->
    <div class="mic-section">
      <button :class="['mic-btn', { listening: isListening }]" @click="toggleMic">
        <span class="mic-icon">{{ isListening ? '️' : '' }}</span>
        <span>{{ isListening ? '正在监听...' : '点击开始' }}</span>
      </button>
      <div v-if="isListening" class="volume-bar">
        <div class="volume-fill" :style="{ width: (volume * 100) + '%' }"></div>
      </div>
    </div>

    <!-- 帮助弹窗 -->
    <div v-if="showHelp" class="help-overlay" @click="showHelp = false">
      <div class="help-content" @click.stop>
        <h3>使用说明</h3>
        <p>1. 选择列，然后点击弦</p>
        <p>2. 点击"点击开始"开启麦克风</p>
        <p>3. 弹奏对应弦，观察仪表盘</p>
        <ul>
          <li>指针偏左 → 偏低 → 紧弦</li>
          <li>指针偏右 → 偏高 → 松弦</li>
          <li>指针居中 → 音准OK</li>
        </ul>
        <button @click="showHelp = false">知道了</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import TunerGauge from '../components/TunerGauge.vue'
import {
  YANGQIN_STRINGS,
  getStringsByRowCol,
  type YangqinString,
} from '../data/yangqin'
import { usePitchDetector } from '../composables/usePitchDetector'

const showHelp = ref(false)
const selectedCol = ref(3)
const selectedStringNum = ref(9)
const a4Ref = ref(440)  // 440 或 442

// 频率转换比例 (442/440)
const freqRatio = computed(() => a4Ref.value / 440)

// 获取当前列的所有弦
const stringsInCol = computed((): YangqinString[] => {
  // 从第1排开始查找该列的弦
  const all: YangqinString[] = []
  for (let row = 1; row <= 4; row++) {
    const strings = getStringsByRowCol(row, selectedCol.value)
    all.push(...strings)
  }
  return all
})

// 选中的弦
const targetString = computed((): YangqinString | null => {
  const s = YANGQIN_STRINGS.find(s => s.stringNum === selectedStringNum.value) || null
  if (!s) return null
  // 根据 a4Ref 转换频率
  return { ...s, frequency: s.frequency * freqRatio.value }
})

// 科学音名转亥姆霍兹音名
const targetNote = computed(() => {
  if (!targetString.value) return '--'
  const note = targetString.value.note
  const match = note.match(/^([#b]?)([A-G])(\d)/)
  if (!match) return note.toLowerCase()
  const accidental = match[1]
  const letter = match[2]
  const octave = parseInt(match[3])
  if (octave >= 4) return `${accidental}${letter.toLowerCase()}${octave - 3}`
  if (octave === 3) return `${accidental}${letter.toLowerCase()}`
  return `${accidental}${letter}`
})

const targetFreq = computed(() => {
  if (!targetString.value) return '--'
  return targetString.value.frequency.toFixed(2)
})

// 音高检测
const { isListening, pitchData, volume, start, stop } = usePitchDetector()

const currentNote = computed(() => pitchData.value.note || '--')
const currentFreq = computed(() => {
  if (!pitchData.value.frequency) return '--'
  return pitchData.value.frequency.toFixed(2)
})

const currentCents = computed(() => {
  if (!targetString.value || !pitchData.value.frequency) return 0
  return Math.round(1200 * Math.log2(pitchData.value.frequency / targetString.value.frequency))
})

const isInTune = computed(() => Math.abs(currentCents.value) <= 5)

const currentNoteClass = computed(() => {
  if (!pitchData.value.frequency) return ''
  if (isInTune.value) return 'correct'
  return 'off'
})

const currentNotation = computed(() => {
  if (!targetString.value) return '--'
  return targetString.value.notation || '?'
})

const tuneStatus = computed(() => {
  if (!pitchData.value.frequency) return '--'
  if (isInTune.value) return '准确'
  if (currentCents.value > 0) return '偏高'
  return '偏低'
})

const tuneStatusClass = computed(() => {
  if (!pitchData.value.frequency) return ''
  if (isInTune.value) return 'correct'
  return 'off'
})

function onColChange(col: number) {
  selectedCol.value = col
  // 自动选择该列的第一根弦
  const strings = getStringsByRowCol(1, col)
  if (strings.length > 0) {
    selectedStringNum.value = strings[0].stringNum
  }
}

function toggleMic() {
  if (isListening.value) stop()
  else start()
}
</script>

<style scoped>
.yangqin-page {
  padding: 0 16px 24px;
  min-height: 100vh;
  background: #faf8f5;
  font-family: -apple-system, BlinkMacSystemFont, "PingFang SC", "Microsoft YaHei", sans-serif;
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0 8px;
}
.back-btn {
  width: 36px; height: 36px;
  border: none; background: none;
  font-size: 24px; color: #333;
  cursor: pointer;
}
.help-btn {
  width: 30px; height: 30px;
  border-radius: 50%;
  border: 1.5px solid #ccc;
  background: none;
  font-size: 14px; color: #999;
  cursor: pointer;
}

/* 信息面板 */
.info-panel {
  padding: 12px 20px;
  border-top: 1px solid #eee;
  border-bottom: 1px solid #eee;
  margin-bottom: 16px;
}
.info-row {
  display: flex;
  align-items: baseline;
  margin-bottom: 10px;
}
.info-row:last-child { margin-bottom: 0; }
.info-item {
  flex: 1;
  display: flex;
  align-items: baseline;
  gap: 6px;
}
.info-label {
  font-size: 14px;
  color: #999;
  min-width: 56px;
}
.info-value {
  font-size: 28px;
  font-weight: 700;
  color: #333;
  transition: color 0.3s;
}
.info-value.correct { color: #333; }
.info-value.off { color: #c0392b; }
.info-unit {
  font-size: 14px;
  color: #999;
  font-weight: 400;
}

/* 440/442 开关 */
.a4-switch {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-bottom: 16px;
}
.a4-btn {
  padding: 8px 24px;
  border: 1.5px solid #ddd;
  border-radius: 20px;
  background: #fff;
  color: #666;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.a4-btn:hover {
  border-color: #bbb;
}
.a4-btn.active {
  border-color: #8B6914;
  background: #8B6914;
  color: #fff;
}

/* 列选择 */
.selector-group {
  margin: 16px 0;
}
.selector-label {
  font-size: 14px;
  color: #999;
  margin-bottom: 8px;
  font-weight: 500;
}
.selector-scroll {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding-bottom: 4px;
}
.selector-scroll::-webkit-scrollbar {
  display: none;
}
.sel-btn {
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  border: 1.5px solid #ddd;
  border-radius: 50%;
  background: #fff;
  color: #666;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.sel-btn:hover { border-color: #bbb; }
.sel-btn.active {
  border-color: #8B6914;
  background: #8B6914;
  color: #fff;
}

/* 弦列表 */
.string-list {
  max-height: 300px;
  overflow-y: auto;
  border: 1px solid #eee;
  border-radius: 12px;
  background: #fff;
}
.string-row {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid #f5f2ed;
  cursor: pointer;
  transition: background 0.15s;
}
.string-row:last-child { border-bottom: none; }
.string-row:hover { background: #f9f5ee; }
.string-row.active { background: #f0ebe0; }
.string-row.active .string-num,
.string-row.active .string-note,
.string-row.active .string-notation {
  color: #333;
  font-weight: 600;
}
.string-num {
  width: 50px;
  font-size: 14px;
  color: #8B6914;
  font-weight: 500;
}
.string-note {
  flex: 1;
  font-size: 16px;
  color: #333;
  font-weight: 600;
}
.string-notation {
  font-size: 14px;
  color: #999;
}

/* 麦克风 */
.mic-section {
  text-align: center;
  padding: 20px 0;
}
.mic-btn {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 14px 36px;
  font-size: 16px;
  font-weight: 500;
  color: #fff;
  background: #8B6914;
  border: none;
  border-radius: 50px;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 12px rgba(139, 105, 20, 0.3);
}
.mic-btn:hover {
  background: #a07d1a;
  transform: translateY(-1px);
}
.mic-btn.listening {
  background: #c0392b;
  box-shadow: 0 4px 12px rgba(192, 57, 43, 0.3);
  animation: micPulse 2s infinite;
}
.mic-icon { font-size: 20px; }
@keyframes micPulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(192, 57, 43, 0.4); }
  50% { box-shadow: 0 0 0 12px rgba(192, 57, 43, 0); }
}
.volume-bar {
  width: 160px;
  height: 4px;
  background: #e0ddd8;
  border-radius: 2px;
  margin: 12px auto 0;
  overflow: hidden;
}
.volume-fill {
  height: 100%;
  background: linear-gradient(90deg, #8B6914, #c0392b);
  border-radius: 2px;
  transition: width 0.05s;
}

/* 帮助弹窗 */
.help-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}
.help-content {
  background: #fff;
  border-radius: 16px;
  padding: 28px 24px;
  max-width: 340px;
  width: 90%;
  box-shadow: 0 8px 32px rgba(0,0,0,0.15);
}
.help-content h3 {
  margin: 0 0 16px;
  font-size: 18px;
  color: #333;
}
.help-content p {
  margin: 8px 0;
  font-size: 14px;
  color: #666;
  line-height: 1.6;
}
.help-content ul {
  margin: 12px 0;
  padding-left: 20px;
}
.help-content li {
  font-size: 14px;
  color: #666;
  margin: 6px 0;
}
.help-content button {
  margin-top: 16px;
  width: 100%;
  padding: 12px;
  background: #8B6914;
  color: #fff;
  border: none;
  border-radius: 10px;
  font-size: 15px;
  cursor: pointer;
}
</style>
