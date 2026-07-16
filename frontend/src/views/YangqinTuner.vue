<template>
  <div class="yangqin-page">
    <!-- Header -->
    <header class="header">
      <router-link to="/" class="back-link">← 返回</router-link>
      <h1>🎶 扬琴调音器</h1>
      <div class="header-right">
        <span class="username" v-if="userInfo">{{ userInfo.nickname || userInfo.username }}</span>
      </div>
    </header>

    <!-- 模式切换 -->
    <div class="mode-tabs">
      <button :class="{ active: mode === 'manual' }" @click="mode = 'manual'">
        ✋ 手动设置
      </button>
      <button :class="{ active: mode === 'auto' }" @click="mode = 'auto'">
        🎯 自动检测
      </button>
    </div>

    <!-- 手动模式: 行列选择器 -->
    <div v-if="mode === 'manual'" class="manual-panel">
      <div class="selector-row">
        <label>行 (从上到下)</label>
        <div class="btn-group">
          <button
            v-for="r in 4" :key="'r' + r"
            :class="['sel-btn', { active: manualRow === r }]"
            @click="manualRow = r"
          >
            第{{ r }}行
          </button>
        </div>
      </div>
      <div class="selector-row">
        <label>列 (从左到右)</label>
        <div class="btn-group">
          <button
            v-for="c in 6" :key="'c' + c"
            :class="['sel-btn', { active: manualCol === c }]"
            @click="manualCol = c"
          >
            第{{ c }}列
          </button>
        </div>
      </div>
      <div v-if="manualString" class="manual-target">
        <span class="mt-pos">第{{ manualString.row }}行 · 第{{ manualString.col }}列</span>
        <span class="mt-note">{{ manualString.label }}</span>
        <span class="mt-freq">{{ manualString.frequency.toFixed(1) }} Hz</span>
      </div>
    </div>

    <!-- 自动模式提示 -->
    <div v-if="mode === 'auto'" class="auto-panel">
      <div v-if="!isListening" class="auto-hint">
        <p>点击下方"开始监听"，弹奏任意弦后自动识别位置并显示调弦方向</p>
      </div>
      <div v-else class="auto-hint listening">
        <p>🎙️ 正在监听... 弹奏一根弦即可识别</p>
      </div>
    </div>

    <!-- 扬琴示意图 -->
    <YangqinSchematic
      :strings="YANGQIN_STRINGS"
      :selected="mode === 'manual' ? manualString : null"
      :detected-string="autoDetectedString"
      :detected-cents="autoCents"
      :detected-in-tune="autoInTune"
      @select="onSchematicSelect"
    />

    <!-- 手动模式: 音高仪表盘 -->
    <template v-if="mode === 'manual' && isListening && manualString">
      <TunerGauge
        :note="pitchData.note"
        :frequency="pitchData.frequency"
        :cents="manualCents"
        :in-tune="Math.abs(manualCents) <= 5"
      />
      <div class="manual-result" :class="{ ok: Math.abs(manualCents) <= 5 }">
        <span v-if="pitchData.note === '--'">等待声音...</span>
        <span v-else-if="Math.abs(manualCents) <= 5">✅ {{ manualString.label }} 已准!</span>
        <span v-else-if="manualCents > 0">⬇ 偏高 {{ manualCents }} cents — 松弦</span>
        <span v-else>⬆ 偏低 {{ Math.abs(manualCents) }} cents — 紧弦</span>
      </div>
    </template>

    <!-- 麦克风控制 -->
    <div class="controls">
      <button :class="['mic-btn', { listening: isListening }]" @click="toggleMic">
        <span class="mic-icon">{{ isListening ? '🎙️' : '🔇' }}</span>
        <span>{{ isListening ? '正在监听...' : '点击开始' }}</span>
      </button>
      <div v-if="isListening" class="volume-bar">
        <div class="volume-fill" :style="{ width: (volume * 100) + '%' }"></div>
      </div>
    </div>

    <!-- 弦列表 (快速跳转) -->
    <div class="string-grid-compact">
      <div class="grid-title">快速选弦</div>
      <div v-for="r in 4" :key="'gr' + r" class="grid-row">
        <span class="grid-row-label">R{{ r }}</span>
        <button
          v-for="c in 6" :key="'gc' + r + c"
          :class="['grid-cell', {
            active: mode === 'manual' && manualRow === r && manualCol === c,
            detected: mode === 'auto' && autoDetectedString?.row === r && autoDetectedString?.col === c
          }]"
          @click="manualRow = r; manualCol = c; mode = 'manual'"
        >
          {{ getLabel(r, c) }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import YangqinSchematic from '../components/YangqinSchematic.vue'
import TunerGauge from '../components/TunerGauge.vue'
import {
  YANGQIN_STRINGS,
  getStringAt,
  findNearestString,
  type YangqinString,
} from '../data/yangqin'
import { usePitchDetector } from '../composables/usePitchDetector'
import type { UserInfo } from '../api'

const userInfo = ref<UserInfo | null>(null)

onMounted(() => {
  const u = localStorage.getItem('user')
  if (u) userInfo.value = JSON.parse(u)
})

const mode = ref<'manual' | 'auto'>('manual')
const manualRow = ref(2)
const manualCol = ref(2)

const { isListening, pitchData, volume, start, stop } = usePitchDetector()

// 手动模式
const manualString = computed(() => getStringAt(manualRow.value, manualCol.value))

const manualCents = computed(() => {
  if (!manualString.value || !pitchData.value.frequency) return 0
  return Math.round(1200 * Math.log2(pitchData.value.frequency / manualString.value.frequency))
})

// 自动模式
const autoDetectedString = ref<YangqinString | null>(null)
const autoCents = ref(0)
const autoInTune = ref(false)

watch(() => pitchData.value.frequency, (freq) => {
  if (mode.value !== 'auto' || !freq) return
  const result = findNearestString(freq)
  if (result && Math.abs(result.cents) < 100) {
    autoDetectedString.value = result.string
    autoCents.value = result.cents
    autoInTune.value = Math.abs(result.cents) <= 5
  }
})

function onSchematicSelect(s: YangqinString) {
  manualRow.value = s.row
  manualCol.value = s.col
  mode.value = 'manual'
}

function getLabel(row: number, col: number): string {
  return getStringAt(row, col)?.label || '--'
}

function toggleMic() {
  if (isListening.value) stop()
  else start()
}
</script>

<style scoped>
.yangqin-page {
  max-width: 600px;
  margin: 0 auto;
  padding: 16px;
  min-height: 100vh;
}

.header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}
.back-link { color: #64748b; text-decoration: none; font-size: 14px; }
.back-link:hover { color: #f1f5f9; }
.header h1 { color: #f1f5f9; font-size: 22px; margin: 0; flex: 1; }
.header-right { display: flex; align-items: center; gap: 8px; }
.username { color: #94a3b8; font-size: 14px; }

/* 模式切换 */
.mode-tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}
.mode-tabs button {
  flex: 1;
  padding: 12px;
  background: #1e293b;
  border: 2px solid #334155;
  border-radius: 12px;
  color: #94a3b8;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.mode-tabs button.active {
  border-color: #3b82f6;
  color: #f1f5f9;
  background: #1e3a8a;
}

/* 手动面板 */
.manual-panel {
  background: #1e293b;
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 16px;
  border: 1px solid #334155;
}
.selector-row {
  margin-bottom: 12px;
}
.selector-row label {
  display: block;
  color: #64748b;
  font-size: 12px;
  margin-bottom: 6px;
}
.btn-group {
  display: flex;
  gap: 6px;
}
.sel-btn {
  flex: 1;
  padding: 8px 4px;
  background: #0f172a;
  border: 2px solid #334155;
  border-radius: 8px;
  color: #94a3b8;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}
.sel-btn:hover { border-color: #64748b; }
.sel-btn.active { border-color: #3b82f6; color: #f1f5f9; background: #1e3a8a; }

.manual-target {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  background: #0f172a;
  border-radius: 8px;
  margin-top: 4px;
}
.mt-pos { color: #64748b; font-size: 12px; }
.mt-note { color: #f1f5f9; font-size: 20px; font-weight: 700; }
.mt-freq { color: #94a3b8; font-size: 14px; }

/* 自动面板 */
.auto-panel {
  margin-bottom: 16px;
}
.auto-hint {
  background: #1e293b;
  border: 1px solid #334155;
  border-radius: 12px;
  padding: 14px;
  text-align: center;
}
.auto-hint p { color: #64748b; font-size: 14px; margin: 0; }
.auto-hint.listening { border-color: #dc2626; background: #3b1111; }
.auto-hint.listening p { color: #fca5a5; }

/* 手动结果 */
.manual-result {
  text-align: center;
  padding: 12px;
  background: #1e293b;
  border-radius: 12px;
  border: 2px solid #334155;
  color: #f87171;
  font-size: 16px;
  font-weight: 600;
  margin-top: 12px;
  transition: all 0.3s;
}
.manual-result.ok { border-color: #22c55e; background: #14532d; color: #4ade80; }

/* 麦克风 */
.controls { text-align: center; margin: 20px 0; }
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
.mic-btn:hover { background: #475569; transform: scale(1.05); }
.mic-btn.listening { background: #991b1b; border-color: #ef4444; animation: pulse 2s infinite; }
.mic-icon { font-size: 22px; }
@keyframes pulse { 0%, 100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.4); } 50% { box-shadow: 0 0 0 12px rgba(239, 68, 68, 0); } }
.volume-bar { width: 200px; height: 4px; background: #334155; border-radius: 2px; margin: 10px auto; overflow: hidden; }
.volume-fill { height: 100%; background: linear-gradient(90deg, #22c55e, #eab308, #ef4444); border-radius: 2px; transition: width 0.05s; }

/* 快速弦网格 */
.string-grid-compact {
  background: #1e293b;
  border-radius: 12px;
  padding: 14px;
  margin-top: 20px;
  border: 1px solid #334155;
}
.grid-title {
  color: #64748b;
  font-size: 12px;
  margin-bottom: 8px;
}
.grid-row {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-bottom: 4px;
}
.grid-row-label {
  width: 28px;
  color: #475569;
  font-size: 11px;
  font-weight: 600;
  text-align: center;
}
.grid-cell {
  flex: 1;
  padding: 8px 2px;
  background: #0f172a;
  border: 1.5px solid #334155;
  border-radius: 6px;
  color: #94a3b8;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s;
  text-align: center;
}
.grid-cell:hover { border-color: #64748b; }
.grid-cell.active { border-color: #3b82f6; color: #f1f5f9; background: #1e3a8a; }
.grid-cell.detected { border-color: #f59e0b; color: #fbbf24; background: #422006; }
</style>
