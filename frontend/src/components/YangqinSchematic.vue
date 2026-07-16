<template>
  <div class="yangqin-schematic">
    <svg :viewBox="`0 0 ${svgW} ${svgH}`" class="schematic-svg" xmlns="http://www.w3.org/2000/svg">
      <!-- 琴身梯形 -->
      <polygon :points="bodyPoints" class="body" />
      <polygon :points="bodyPoints" class="body-border" fill="none" stroke="#8B6914" stroke-width="3" />

      <!-- 码子竖线 -->
      <line :x1="leftBridgeX" :y1="topY" :x2="leftBridgeX" :y2="bottomY" class="bridge-line" />
      <line :x1="midBridgeX" :y1="topY" :x2="midBridgeX" :y2="bottomY" class="bridge-line" />
      <line :x1="rightBridgeX" :y1="topY" :x2="rightBridgeX" :y2="bottomY" class="bridge-line" />

      <!-- 码子标签 -->
      <text :x="leftBridgeX" :y="topY - 14" class="bridge-label">左码</text>
      <text :x="midBridgeX" :y="topY - 14" class="bridge-label">中码</text>
      <text :x="rightBridgeX" :y="topY - 14" class="bridge-label">右码</text>

      <!-- 行标签 + 弦 -->
      <g v-for="r in rows" :key="r">
        <text :x="30" :y="rowY(r) + 4" class="row-label" text-anchor="middle">第{{ r }}行</text>
      </g>

      <!-- 所有弦 -->
      <g v-for="(row, ri) in strings" :key="'row-' + ri">
        <g v-for="(s, ci) in row" :key="'s-' + ri + '-' + ci">
          <!-- 弦竖线 -->
          <line
            :x1="stringX(s.col)"
            :y1="rowY(s.row) - 8"
            :x2="stringX(s.col)"
            :y2="rowY(s.row) + 8"
            :class="['string-line', { active: isSelected(s), detected: isDetected(s) }]"
          />
          <!-- 弦圆点 -->
          <circle
            :cx="stringX(s.col)"
            :cy="rowY(s.row)"
            :r="isSelected(s) ? 14 : isDetected(s) ? 12 : 8"
            :class="['string-dot', {
              active: isSelected(s),
              detected: isDetected(s),
              'in-tune': isDetected(s) && detectedInTune,
              'out-tune': isDetected(s) && !detectedInTune
            }]"
            @click="$emit('select', s)"
          />
          <!-- 音名标签 -->
          <text
            :x="stringX(s.col)"
            :y="rowY(s.row) + (isSelected(s) ? 30 : isDetected(s) ? 28 : 22)"
            :class="['string-label', { active: isSelected(s), detected: isDetected(s) }]"
            text-anchor="middle"
          >
            {{ s.label }}
          </text>
          <!-- 方向箭头 (仅检测到的弦) -->
          <g v-if="isDetected(s) && arrowDir">
            <polygon
              :points="arrowDir === 'up' ? '-7,6 0,-5 7,6' : '-7,-6 0,5 7,-6'"
              :transform="`translate(${stringX(s.col)}, ${rowY(s.row) - 22})`"
              :class="['arrow', arrowDir]"
            />
          </g>
        </g>
      </g>
    </svg>

    <!-- 调弦方向提示面板 -->
    <div v-if="detectedString" class="tune-hint" :class="hintClass">
      <div class="hint-row-pos">第 {{ detectedString.row }} 行 · 第 {{ detectedString.col }} 列</div>
      <div class="hint-string">{{ detectedString.label }} ({{ detectedString.frequency.toFixed(1) }} Hz)</div>
      <div class="hint-direction">
        <span v-if="arrowDir === 'up'" class="dir-text tight">⬆ 偏低 — 紧弦</span>
        <span v-else-if="arrowDir === 'down'" class="dir-text loose">⬇ 偏高 — 松弦</span>
        <span v-else class="dir-text ok">✅ 音准OK</span>
      </div>
      <div class="hint-cents">{{ detectedCents > 0 ? '+' : '' }}{{ detectedCents }} cents</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { YANGQIN_ROWS, type YangqinString } from '../data/yangqin'

const props = defineProps<{
  strings: YangqinString[][]
  selected: YangqinString | null
  detectedString: YangqinString | null
  detectedCents: number
  detectedInTune: boolean
}>()

defineEmits(['select'])

const rows = YANGQIN_ROWS
const svgW = 520
const svgH = 370
const topY = 50
const bottomY = 320
const leftX = 60
const rightX = 470
const leftBridgeX = 160
const midBridgeX = 270
const rightBridgeX = 380

const bodyPoints = computed(() => {
  const inset = 20
  return `${leftX + inset},${topY} ${rightX - inset},${topY} ${rightX},${bottomY} ${leftX},${bottomY}`
})

function rowY(row: number): number {
  return topY + ((row - 0.5) / YANGQIN_ROWS) * (bottomY - topY)
}

function stringX(col: number): number {
  return leftX + 40 + ((col - 1) / 5) * (rightX - leftX - 80)
}

function isSelected(s: YangqinString): boolean {
  return !!props.selected && props.selected.row === s.row && props.selected.col === s.col
}

function isDetected(s: YangqinString): boolean {
  return !!props.detectedString && props.detectedString.row === s.row && props.detectedString.col === s.col
}

const arrowDir = computed<'up' | 'down' | null>(() => {
  if (!props.detectedString) return null
  if (props.detectedInTune) return null
  return props.detectedCents > 0 ? 'down' : 'up'
})

const hintClass = computed(() => {
  if (!props.detectedString) return ''
  if (props.detectedInTune) return 'ok'
  return props.detectedCents > 0 ? 'down' : 'up'
})
</script>

<style scoped>
.yangqin-schematic {
  margin: 16px auto;
  max-width: 540px;
}

.schematic-svg {
  width: 100%;
  height: auto;
  display: block;
}

.body { fill: #1c1508; }
.body-border { stroke: #8B6914; }

.bridge-line {
  stroke: #5a4a2a;
  stroke-width: 2;
  stroke-dasharray: 5 3;
}

.bridge-label {
  fill: #a08030;
  font-size: 11px;
  text-anchor: middle;
  font-weight: 600;
}

.row-label {
  fill: #475569;
  font-size: 10px;
}

.string-line {
  stroke: #334155;
  stroke-width: 1.5;
  transition: all 0.2s;
}
.string-line.active { stroke: #3b82f6; stroke-width: 2.5; }
.string-line.detected { stroke: #f59e0b; stroke-width: 2.5; }

.string-dot {
  fill: #1e293b;
  stroke: #475569;
  stroke-width: 1.5;
  cursor: pointer;
  transition: all 0.25s;
}
.string-dot:hover { fill: #334155; stroke: #64748b; }
.string-dot.active { fill: #1d4ed8; stroke: #60a5fa; stroke-width: 2; }
.string-dot.detected { fill: #b45309; stroke: #fbbf24; stroke-width: 2; }
.string-dot.in-tune { fill: #15803d; stroke: #4ade80; stroke-width: 2; }
.string-dot.out-tune { fill: #b91c1c; stroke: #f87171; stroke-width: 2; }

.string-label {
  fill: #475569;
  font-size: 10px;
  transition: all 0.2s;
}
.string-label.active { fill: #60a5fa; font-weight: 700; font-size: 13px; }
.string-label.detected { fill: #fbbf24; font-weight: 700; font-size: 13px; }

.arrow { transition: all 0.2s; }
.arrow.up { fill: #ef4444; }
.arrow.down { fill: #ef4444; }

/* 调弦提示面板 */
.tune-hint {
  text-align: center;
  padding: 14px 16px;
  background: #1e293b;
  border-radius: 12px;
  border: 2px solid #334155;
  margin-top: 12px;
  transition: all 0.3s;
}
.tune-hint.up, .tune-hint.down { border-color: #dc2626; background: #3b1111; }
.tune-hint.ok { border-color: #16a34a; background: #0c2e16; }

.hint-row-pos {
  color: #64748b;
  font-size: 12px;
  margin-bottom: 2px;
}

.hint-string {
  color: #f1f5f9;
  font-size: 18px;
  font-weight: 700;
}

.hint-direction { margin: 6px 0; }

.dir-text { font-size: 22px; font-weight: 700; }
.dir-text.tight { color: #f87171; }
.dir-text.loose { color: #f87171; }
.dir-text.ok { color: #4ade80; }

.hint-cents {
  color: #94a3b8;
  font-size: 13px;
}
</style>
