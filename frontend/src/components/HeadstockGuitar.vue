<template>
  <svg viewBox="0 0 320 300" class="headstock-svg">
    <defs>
      <linearGradient id="woodG" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" stop-color="#C4A030"/>
        <stop offset="25%" stop-color="#B8922E"/>
        <stop offset="50%" stop-color="#A07820"/>
        <stop offset="75%" stop-color="#8B6914"/>
        <stop offset="100%" stop-color="#7A5C10"/>
      </linearGradient>
      <radialGradient id="pegG" cx="35%" cy="30%">
        <stop offset="0%" stop-color="#fff"/>
        <stop offset="25%" stop-color="#ececec"/>
        <stop offset="60%" stop-color="#c0c0c0"/>
        <stop offset="100%" stop-color="#888"/>
      </radialGradient>
      <linearGradient id="neckG" x1="0%" y1="0%" x2="100%" y2="0%">
        <stop offset="0%" stop-color="#2a1a0a"/>
        <stop offset="15%" stop-color="#3a2815"/>
        <stop offset="50%" stop-color="#4a3520"/>
        <stop offset="85%" stop-color="#3a2815"/>
        <stop offset="100%" stop-color="#2a1a0a"/>
      </linearGradient>
      <linearGradient id="fretG" x1="0%" y1="0%" x2="100%" y2="0%">
        <stop offset="0%" stop-color="#b0a080"/>
        <stop offset="50%" stop-color="#d8d0b8"/>
        <stop offset="100%" stop-color="#b0a080"/>
      </linearGradient>
      <filter id="ps">
        <feDropShadow dx="0" dy="1" stdDeviation="1.2" flood-color="#000" flood-opacity="0.45"/>
      </filter>
    </defs>

    <!-- 琴颈 -->
    <rect x="128" y="162" width="64" height="138" rx="2" fill="url(#neckG)"/>
    <!-- 品丝 -->
    <line x1="128" y1="188" x2="192" y2="188" stroke="url(#fretG)" stroke-width="2.5"/>
    <line x1="128" y1="216" x2="192" y2="216" stroke="url(#fretG)" stroke-width="2.5"/>
    <line x1="128" y1="244" x2="192" y2="244" stroke="url(#fretG)" stroke-width="2.5"/>
    <line x1="128" y1="272" x2="192" y2="272" stroke="url(#fretG)" stroke-width="2.5"/>
    <!-- 指板中线 -->
    <circle cx="160" cy="202" r="3" fill="#d8d0b8" opacity="0.4"/>
    <circle cx="160" cy="258" r="3" fill="#d8d0b8" opacity="0.4"/>

    <!-- 琴头 (3+3 造型，更短) -->
    <path d="M 125,30 L 125,150 Q 125,162 137,162 L 183,162 Q 195,162 195,150 L 195,30 Q 195,10 160,5 Q 125,10 125,30 Z"
          fill="url(#woodG)" stroke="#5a4010" stroke-width="1.5"/>

    <!-- 琴头顶部弧线装饰 -->
    <path d="M 128,28 Q 128,12 160,8 Q 192,12 192,28" fill="none" stroke="#6a5010" stroke-width="1.2" opacity="0.5"/>
    <path d="M 131,26 Q 131,15 160,11 Q 189,15 189,26" fill="none" stroke="#6a5010" stroke-width="0.6" opacity="0.3"/>

    <!-- 木纹 -->
    <clipPath id="hc"><path d="M 125,30 L 125,150 Q 125,162 137,162 L 183,162 Q 195,162 195,150 L 195,30 Q 195,10 160,5 Q 125,10 125,30 Z"/></clipPath>
    <g clip-path="url(#hc)">
      <path d="M 135,33 Q 132,90 138,148" fill="none" stroke="#b89020" stroke-width="0.5" opacity="0.3"/>
      <path d="M 147,31 Q 145,90 150,150" fill="none" stroke="#b89020" stroke-width="0.4" opacity="0.2"/>
      <path d="M 160,29 Q 160,90 162,152" fill="none" stroke="#b89020" stroke-width="0.5" opacity="0.3"/>
      <path d="M 173,31 Q 175,90 176,150" fill="none" stroke="#b89020" stroke-width="0.4" opacity="0.2"/>
      <path d="M 185,33 Q 188,90 190,148" fill="none" stroke="#b89020" stroke-width="0.5" opacity="0.3"/>
    </g>

    <!-- 弦枕 -->
    <rect x="124" y="158" width="72" height="6" rx="2" fill="#f0ead8" stroke="#d0c8a8" stroke-width="0.5"/>

    <!-- 琴弦 -->
    <line x1="138" y1="60" x2="142" y2="300" stroke="#ddd8c8" stroke-width="2.2" opacity="0.45"/>
    <line x1="138" y1="95" x2="150" y2="300" stroke="#ddd8c8" stroke-width="2.8" opacity="0.45"/>
    <line x1="138" y1="130" x2="158" y2="300" stroke="#ddd8c8" stroke-width="3.2" opacity="0.45"/>
    <line x1="182" y1="60" x2="178" y2="300" stroke="#ddd8c8" stroke-width="1.6" opacity="0.45"/>
    <line x1="182" y1="95" x2="170" y2="300" stroke="#ddd8c8" stroke-width="1.2" opacity="0.45"/>
    <line x1="182" y1="130" x2="162" y2="300" stroke="#ddd8c8" stroke-width="1" opacity="0.45"/>

    <!-- 左排弦钮 (4, 5, 6) - 位置更紧凑 -->
    <g v-for="peg in leftPegs" :key="'l'+peg.num">
      <rect :x="peg.x - 4" :y="peg.y - 2" width="18" height="4" rx="1" fill="#aaa" stroke="#888" stroke-width="0.5"/>
      <circle :cx="peg.x" :cy="peg.y" r="11" fill="url(#pegG)" stroke="#999" stroke-width="0.8" filter="url(#ps)"/>
      <circle :cx="peg.x" :cy="peg.y" r="5" fill="#c8c8c8" stroke="#aaa" stroke-width="0.5"/>
      <line :x1="peg.x-3" :y1="peg.y" :x2="peg.x+3" :y2="peg.y" stroke="#999" stroke-width="0.7"/>
      <line :x1="peg.x" :y1="peg.y-3" :x2="peg.x" :y2="peg.y+3" stroke="#999" stroke-width="0.7"/>
    </g>

    <!-- 右排弦钮 (3, 2, 1) -->
    <g v-for="peg in rightPegs" :key="'r'+peg.num">
      <rect :x="peg.x - 14" :y="peg.y - 2" width="18" height="4" rx="1" fill="#aaa" stroke="#888" stroke-width="0.5"/>
      <circle :cx="peg.x" :cy="peg.y" r="11" fill="url(#pegG)" stroke="#999" stroke-width="0.8" filter="url(#ps)"/>
      <circle :cx="peg.x" :cy="peg.y" r="5" fill="#c8c8c8" stroke="#aaa" stroke-width="0.5"/>
      <line :x1="peg.x-3" :y1="peg.y" :x2="peg.x+3" :y2="peg.y" stroke="#999" stroke-width="0.7"/>
      <line :x1="peg.x" :y1="peg.y-3" :x2="peg.x" :y2="peg.y+3" stroke="#999" stroke-width="0.7"/>
    </g>

    <!-- 左侧标签: 音名 + 编号 -->
    <g v-for="peg in leftPegs" :key="'ll'+peg.num">
      <text :x="75" :y="peg.y + 5" text-anchor="end" font-size="16" font-weight="700"
            fill="#fff" class="note-text" @click="$emit('changeNote', peg.num)"
            style="cursor:pointer">{{ getNote(peg.num) }}</text>
      <rect :x="82" :y="peg.y - 13" width="26" height="26" rx="6"
            :class="['num-bg', {active: activePeg === peg.num}]"
            @click="$emit('select', peg.num)" style="cursor:pointer"/>
      <text :x="95" :y="peg.y + 5" text-anchor="middle" font-size="13" font-weight="700"
            :class="['num-text', {active: activePeg === peg.num}]"
            @click="$emit('select', peg.num)" style="cursor:pointer">{{ peg.num }}</text>
    </g>

    <!-- 右侧标签: 编号 + 音名 -->
    <g v-for="peg in rightPegs" :key="'rl'+peg.num">
      <rect :x="200" :y="peg.y - 13" width="26" height="26" rx="6"
            :class="['num-bg', {active: activePeg === peg.num}]"
            @click="$emit('select', peg.num)" style="cursor:pointer"/>
      <text :x="213" :y="peg.y + 5" text-anchor="middle" font-size="13" font-weight="700"
            :class="['num-text', {active: activePeg === peg.num}]"
            @click="$emit('select', peg.num)" style="cursor:pointer">{{ peg.num }}</text>
      <text :x="235" :y="peg.y + 5" text-anchor="start" font-size="16" font-weight="700"
            fill="#fff" class="note-text" @click="$emit('changeNote', peg.num)"
            style="cursor:pointer">{{ getNote(peg.num) }}</text>
    </g>
  </svg>
</template>

<script setup lang="ts">
const props = defineProps<{
  activePeg?: number
  stringNotes?: string[]
}>()
defineEmits<{ select: [n: number]; changeNote: [n: number] }>()

// 弦钮位置 - 更紧凑的间距
const leftPegs = [
  { num: 4, x: 138, y: 60 },
  { num: 5, x: 138, y: 95 },
  { num: 6, x: 138, y: 130 },
]
const rightPegs = [
  { num: 3, x: 182, y: 60 },
  { num: 2, x: 182, y: 95 },
  { num: 1, x: 182, y: 130 },
]

function getNote(num: number): string {
  if (!props.stringNotes) return '--'
  return props.stringNotes[num - 1] || '--'
}
</script>

<style scoped>
.headstock-svg {
  width: 100%;
  max-width: 320px;
  height: auto;
  display: block;
}

.num-bg {
  fill: #222;
  stroke: #555;
  stroke-width: 1.5;
  transition: all 0.2s;
}
.num-bg.active {
  fill: rgba(168,85,247,0.25);
  stroke: #a855f7;
  stroke-width: 2;
}
.num-text {
  fill: #ccc;
  transition: fill 0.2s;
  user-select: none;
}
.num-text.active {
  fill: #fff;
}
.note-text {
  transition: opacity 0.2s;
  user-select: none;
}
.note-text:hover {
  opacity: 0.7;
}
</style>
