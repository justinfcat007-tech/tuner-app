<template>
  <div class="app">
    <!-- Header -->
    <header class="header">
      <div class="header-left">
        <h1 class="title">🎶 调音器</h1>
      </div>
      <div class="header-right">
        <router-link to="/vip" class="vip-badge" v-if="userInfo">
          <span v-if="userInfo.vip_level > 0" class="vip-tag">VIP{{ userInfo.vip_level }}</span>
          <span v-else class="vip-tag free">升级VIP</span>
        </router-link>
        <span class="username" v-if="userInfo">{{ userInfo.nickname || userInfo.username }}</span>
        <button class="logout-btn" @click="logout">退出</button>
      </div>
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
    <div v-if="targetString" class="target-info" :class="{ match: isMatch }">
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

    <!-- 扬琴专属入口 -->
    <div v-if="currentInstrument.id === 'yangqin'" class="yangqin-entry">
      <router-link to="/yangqin" class="yangqin-btn">
        🎶 打开扬琴调音器 (手动/自动模式 + 示意图)
      </router-link>
    </div>

    <footer class="footer">
      <p>基于 Web Audio API · 自动检测音高 · 支持标准调弦</p>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import TunerGauge from '../components/TunerGauge.vue'
import StringSelector from '../components/StringSelector.vue'
import { instruments, type Instrument } from '../data/tunings'
import { usePitchDetector } from '../composables/usePitchDetector'
import type { UserInfo } from '../api'

const router = useRouter()
const currentInstrument = ref(instruments[1])
const selectedStringIndex = ref<number | null>(null)
const userInfo = ref<UserInfo | null>(null)

const { isListening, pitchData, volume, start, stop } = usePitchDetector()

onMounted(() => {
  const u = localStorage.getItem('user')
  if (u) userInfo.value = JSON.parse(u)
})

function selectInstrument(inst: Instrument) {
  currentInstrument.value = inst
  selectedStringIndex.value = null
}

function toggleMic() {
  if (isListening.value) stop()
  else start()
}

function logout() {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
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
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.title {
  font-size: 28px;
  font-weight: 700;
  color: #f1f5f9;
  margin: 0;
}

.vip-badge { text-decoration: none; }

.vip-tag {
  padding: 4px 10px;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #fff;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 700;
}

.vip-tag.free {
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
}

.username {
  color: #94a3b8;
  font-size: 14px;
}

.logout-btn {
  padding: 6px 14px;
  background: #334155;
  border: 1px solid #475569;
  border-radius: 8px;
  color: #94a3b8;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}

.logout-btn:hover {
  background: #475569;
  color: #f1f5f9;
}

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

.tab-btn:hover { border-color: #64748b; transform: translateY(-2px); }
.tab-btn.active { border-color: #3b82f6; background: #1e3a8a; box-shadow: 0 4px 20px rgba(59, 130, 246, 0.3); }
.tab-emoji { font-size: 28px; margin-bottom: 4px; }
.tab-name { font-size: 16px; font-weight: 600; color: #f1f5f9; }
.tab-name-en { font-size: 11px; color: #64748b; }

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

.target-info.match { border-color: #22c55e; background: #14532d; }
.target-label { font-size: 12px; color: #64748b; text-transform: uppercase; letter-spacing: 1px; }
.target-note { font-size: 36px; font-weight: 700; color: #f1f5f9; }
.target-freq { font-size: 14px; color: #94a3b8; }
.target-name { font-size: 12px; color: #64748b; margin-top: 4px; }
.match-indicator { margin-top: 8px; font-size: 16px; font-weight: 600; }

.controls { text-align: center; margin: 24px 0; }

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

.volume-bar { width: 200px; height: 4px; background: #334155; border-radius: 2px; margin: 12px auto; overflow: hidden; }
.volume-fill { height: 100%; background: linear-gradient(90deg, #22c55e, #eab308, #ef4444); border-radius: 2px; transition: width 0.05s; }

.footer { text-align: center; margin-top: 40px; padding: 20px; color: #475569; font-size: 12px; }

.yangqin-entry {
  text-align: center;
  margin: 20px 0;
}
.yangqin-btn {
  display: inline-block;
  padding: 14px 28px;
  background: linear-gradient(135deg, #8B6914, #a08030);
  color: #fff;
  border-radius: 12px;
  font-size: 15px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.2s;
}
.yangqin-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 16px rgba(139, 105, 20, 0.4); }
</style>
