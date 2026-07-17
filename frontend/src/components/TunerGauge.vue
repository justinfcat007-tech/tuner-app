<template>
  <div class="gauge-container">
    <svg :viewBox="`0 0 400 240`" class="gauge-svg">
      <!-- 背景弧线 -->
      <path :d="arcPath(170, 180, 0)" fill="none" stroke="#e8ddd0" stroke-width="6" stroke-linecap="round"/>

      <!-- 音准区域颜色 -->
      <!-- 绿色区域: -10 到 +10 cents -->
      <path :d="arcPath(170, angleForCents(-10), angleForCents(10))" fill="none" stroke="#8fbc8f" stroke-width="8" stroke-linecap="round" opacity="0.5"/>
      <!-- 黄色区域: -20 到 -10 和 +10 到 +20 -->
      <path :d="arcPath(170, angleForCents(-20), angleForCents(-10))" fill="none" stroke="#daa520" stroke-width="8" stroke-linecap="round" opacity="0.4"/>
      <path :d="arcPath(170, angleForCents(10), angleForCents(20))" fill="none" stroke="#daa520" stroke-width="8" stroke-linecap="round" opacity="0.4"/>
      <!-- 红色区域: -30 到 -20 和 +20 到 +30 -->
      <path :d="arcPath(170, angleForCents(-30), angleForCents(-20))" fill="none" stroke="#cd5c5c" stroke-width="8" stroke-linecap="round" opacity="0.4"/>
      <path :d="arcPath(170, angleForCents(20), angleForCents(30))" fill="none" stroke="#cd5c5c" stroke-width="8" stroke-linecap="round" opacity="0.4"/>

      <!-- 木质标记块 (-30, -20, -10, 0, 10, 20, 30) -->
      <g v-for="v in [-30, -20, -10, 0, 10, 20, 30]" :key="'block-' + v">
        <rect
          :x="markerX(v) - 8"
          :y="markerY(v) - 12"
          width="16"
          height="24"
          rx="3"
          fill="#c4956a"
          stroke="#8b6914"
          stroke-width="1"
          :transform="`rotate(${angleForCents(v) + 90}, ${markerX(v)}, ${markerY(v)})`"
        />
      </g>

      <!-- 小刻度线 -->
      <g v-for="v in minorTicks" :key="'tick-' + v">
        <line
          :x1="170 + 155 * Math.cos(angleForCents(v))"
          :y1="210 + 155 * Math.sin(angleForCents(v))"
          :x2="170 + 165 * Math.cos(angleForCents(v))"
          :y2="210 + 165 * Math.sin(angleForCents(v))"
          stroke="#b0a090"
          stroke-width="1.5"
        />
      </g>

      <!-- 数字标签 -->
      <g v-for="v in [-30, -20, -10, 0, 10, 20, 30]" :key="'label-' + v">
        <text
          :x="170 + 130 * Math.cos(angleForCents(v))"
          :y="210 + 130 * Math.sin(angleForCents(v))"
          :fill="Math.abs(v) <= 10 ? '#6b8e23' : '#cd5c5c'"
          font-size="13"
          text-anchor="middle"
          font-weight="600"
          font-family="Arial, sans-serif"
        >{{ v }}</text>
      </g>

      <!-- 指针 -->
      <g :transform="`rotate(${needleAngle}, 170, 210)`" class="needle-group" style="transition: transform 0.15s ease-out;">
        <!-- 指针杆 -->
        <line x1="170" y1="210" x2="170" y2="60" stroke="#c0c0c0" stroke-width="2.5" stroke-linecap="round"/>
        <!-- 指针金属球 -->
        <circle cx="170" cy="210" r="14" fill="url(#metalGradient)" stroke="#999" stroke-width="1"/>
        <circle cx="170" cy="210" r="10" fill="url(#metalInner)" />
      </g>

      <!-- 金属渐变定义 -->
      <defs>
        <radialGradient id="metalGradient" cx="40%" cy="35%">
          <stop offset="0%" stop-color="#f0f0f0"/>
          <stop offset="50%" stop-color="#c0c0c0"/>
          <stop offset="100%" stop-color="#808080"/>
        </radialGradient>
        <radialGradient id="metalInner" cx="40%" cy="35%">
          <stop offset="0%" stop-color="#e8e8e8"/>
          <stop offset="100%" stop-color="#a0a0a0"/>
        </radialGradient>
      </defs>

      <!-- 音准时的绿色光晕 (仅在接收到音频信号时显示) -->
      <circle v-if="inTune && active" cx="170" cy="210" r="20" fill="#22c55e" opacity="0.3">
        <animate attributeName="r" values="18;24;18" dur="1.5s" repeatCount="indefinite"/>
        <animate attributeName="opacity" values="0.3;0.1;0.3" dur="1.5s" repeatCount="indefinite"/>
      </circle>
    </svg>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  cents: number
  inTune: boolean
  active?: boolean  // 是否正在接收音频信号
}>()

// 生成小刻度 (每2 cents一个，排除已有的大刻度)
const minorTicks = computed(() => {
  const ticks: number[] = []
  for (let v = -30; v <= 30; v += 2) {
    if (v % 10 !== 0) ticks.push(v)
  }
  return ticks
})

// cents 值映射到弧度 (半圆 180°)
// SVG 坐标系: 0°=右, 90°=下, 180°=左, 270°=上
// -30 cents = π (最左), 0 cents = 3π/2 (顶部), +30 cents = 2π (最右)
function angleForCents(cents: number): number {
  return Math.PI + Math.PI * (cents + 30) / 60
}

// 木质标记块位置
function markerX(cents: number): number {
  return 170 + 170 * Math.cos(angleForCents(cents))
}
function markerY(cents: number): number {
  return 210 + 170 * Math.sin(angleForCents(cents))
}

// 弧线路径
function arcPath(r: number, startRad: number, endRad: number): string {
  const cx = 170, cy = 210
  const x1 = cx + r * Math.cos(startRad)
  const y1 = cy + r * Math.sin(startRad)
  const x2 = cx + r * Math.cos(endRad)
  const y2 = cy + r * Math.sin(endRad)
  const largeArc = endRad - startRad > Math.PI ? 1 : 0
  return `M ${x1} ${y1} A ${r} ${r} 0 ${largeArc} 1 ${x2} ${y2}`
}

// 指针角度 (SVG rotate 用度数，0°=向上)
const needleAngle = computed(() => {
  const clamped = Math.max(-30, Math.min(30, props.cents))
  // -30 cents = -90° (指向左), 0 = 0° (指向上), +30 = +90° (指向右)
  return (clamped / 30) * 90
})
</script>

<style scoped>
.gauge-container {
  display: flex;
  justify-content: center;
  padding: 10px 0;
}

.gauge-svg {
  width: 100%;
  max-width: 420px;
  height: auto;
}

.needle-group {
  transition: transform 0.15s ease-out;
}
</style>
