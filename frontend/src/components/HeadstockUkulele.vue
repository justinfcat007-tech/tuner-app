<template>
  <svg viewBox="0 0 400 260" class="headstock-svg">
    <defs>
      <linearGradient id="woodGU" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" stop-color="#8B6914"/>
        <stop offset="30%" stop-color="#a0782a"/>
        <stop offset="60%" stop-color="#7a5c10"/>
        <stop offset="100%" stop-color="#6b5010"/>
      </linearGradient>
      <radialGradient id="pegGU" cx="40%" cy="35%">
        <stop offset="0%" stop-color="#f0f0f0"/>
        <stop offset="50%" stop-color="#c0c0c0"/>
        <stop offset="100%" stop-color="#808080"/>
      </radialGradient>
      <linearGradient id="neckGU" x1="0%" y1="0%" x2="0%" y2="100%">
        <stop offset="0%" stop-color="#3a2a1a"/>
        <stop offset="50%" stop-color="#4a3520"/>
        <stop offset="100%" stop-color="#3a2a1a"/>
      </linearGradient>
      <filter id="shadowU">
        <feDropShadow dx="0" dy="1" stdDeviation="1" flood-color="#000" flood-opacity="0.4"/>
      </filter>
    </defs>

    <!-- 琴颈 -->
    <rect x="260" y="100" width="140" height="60" rx="2" fill="url(#neckGU)"/>
    <!-- 品丝 -->
    <line x1="290" y1="100" x2="290" y2="160" stroke="#c0b090" stroke-width="2"/>
    <line x1="320" y1="100" x2="320" y2="160" stroke="#c0b090" stroke-width="2"/>
    <line x1="350" y1="100" x2="350" y2="160" stroke="#c0b090" stroke-width="2"/>
    <line x1="380" y1="100" x2="380" y2="160" stroke="#c0b090" stroke-width="2"/>

    <!-- 琴头 -->
    <path d="M 100,85 Q 100,75 115,75 L 250,75 Q 265,75 265,90 L 265,150 Q 265,165 250,165 L 130,165 Q 100,165 90,150 L 80,130 Q 75,110 100,85 Z"
          fill="url(#woodGU)" stroke="#5a4010" stroke-width="1.5"/>

    <!-- 木纹 -->
    <path d="M 110,90 Q 150,88 250,92" fill="none" stroke="#9a7820" stroke-width="0.5" opacity="0.4"/>
    <path d="M 105,110 Q 150,108 255,112" fill="none" stroke="#9a7820" stroke-width="0.5" opacity="0.3"/>
    <path d="M 100,130 Q 150,128 258,132" fill="none" stroke="#9a7820" stroke-width="0.5" opacity="0.4"/>
    <path d="M 105,150 Q 150,148 255,152" fill="none" stroke="#9a7820" stroke-width="0.5" opacity="0.3"/>

    <!-- Logo -->
    <circle cx="140" cy="120" r="16" fill="none" stroke="#5a4010" stroke-width="1.2" opacity="0.5"/>
    <text x="140" y="125" text-anchor="middle" font-size="13" fill="#5a4010" opacity="0.5" font-weight="bold">U</text>

    <!-- 弦枕 -->
    <rect x="256" y="97" width="6" height="66" rx="2" fill="#f0ead8" stroke="#d0c8a8" stroke-width="0.5"/>

    <!-- 琴弦 -->
    <line x1="135" y1="105" x2="256" y2="108" stroke="#e8e0d0" stroke-width="1.5" opacity="0.7"/>
    <line x1="185" y1="105" x2="256" y2="118" stroke="#e8e0d0" stroke-width="1.8" opacity="0.7"/>
    <line x1="135" y1="135" x2="256" y2="132" stroke="#e8e0d0" stroke-width="2" opacity="0.7"/>
    <line x1="185" y1="135" x2="256" y2="142" stroke="#e8e0d0" stroke-width="2.2" opacity="0.7"/>

    <!-- 上排弦钮 (2, 1) -->
    <g v-for="peg in topPegs" :key="'top-' + peg.num">
      <circle :cx="peg.x" :cy="peg.y" r="11" fill="url(#pegGU)" stroke="#999" stroke-width="0.8" filter="url(#shadowU)"/>
      <circle :cx="peg.x" :cy="peg.y" r="5" fill="#c0c0c0"/>
      <line :x1="peg.x-3" :y1="peg.y" :x2="peg.x+3" :y2="peg.y" stroke="#999" stroke-width="0.7"/>
      <circle v-if="activePeg === peg.num" :cx="peg.x" :cy="peg.y" r="15" fill="none" stroke="#a855f7" stroke-width="2"/>
    </g>

    <!-- 下排弦钮 (3, 4) -->
    <g v-for="peg in bottomPegs" :key="'bottom-' + peg.num">
      <circle :cx="peg.x" :cy="peg.y" r="11" fill="url(#pegGU)" stroke="#999" stroke-width="0.8" filter="url(#shadowU)"/>
      <circle :cx="peg.x" :cy="peg.y" r="5" fill="#c0c0c0"/>
      <line :x1="peg.x-3" :y1="peg.y" :x2="peg.x+3" :y2="peg.y" stroke="#999" stroke-width="0.7"/>
      <circle v-if="activePeg === peg.num" :cx="peg.x" :cy="peg.y" r="15" fill="none" stroke="#a855f7" stroke-width="2"/>
    </g>

    <!-- 上排编号标签 -->
    <g v-for="peg in topPegs" :key="'tl-' + peg.num">
      <rect :x="peg.x - 18" :y="peg.y - 38" width="36" height="24" rx="7"
            :class="['label-bg', {active: activePeg === peg.num}]"
            @click="$emit('select', peg.num)" style="cursor:pointer"/>
      <text :x="peg.x" :y="peg.y - 22" text-anchor="middle" font-size="13" font-weight="700"
            :class="['label-text', {active: activePeg === peg.num}]"
            @click="$emit('select', peg.num)" style="cursor:pointer">{{ peg.num }}</text>
    </g>

    <!-- 下排编号标签 -->
    <g v-for="peg in bottomPegs" :key="'bl-' + peg.num">
      <rect :x="peg.x - 18" :y="peg.y + 14" width="36" height="24" rx="7"
            :class="['label-bg', {active: activePeg === peg.num}]"
            @click="$emit('select', peg.num)" style="cursor:pointer"/>
      <text :x="peg.x" :y="peg.y + 30" text-anchor="middle" font-size="13" font-weight="700"
            :class="['label-text', {active: activePeg === peg.num}]"
            @click="$emit('select', peg.num)" style="cursor:pointer">{{ peg.num }}</text>
    </g>
  </svg>
</template>

<script setup lang="ts">
defineProps<{
  activePeg?: number
  stringNotes?: string[]
}>()

defineEmits<{
  select: [n: number]
  changeNote: [n: number]
}>()

const topPegs = [
  { num: 2, x: 135, y: 105 },
  { num: 1, x: 185, y: 105 },
]

const bottomPegs = [
  { num: 3, x: 135, y: 135 },
  { num: 4, x: 185, y: 135 },
]
</script>

<style scoped>
.headstock-svg {
  width: 100%;
  max-width: 400px;
  height: auto;
  display: block;
}

.label-bg {
  fill: transparent;
  stroke: #aaa;
  stroke-width: 1.5;
  transition: all 0.2s;
}
.label-bg.active {
  stroke: #a855f7;
  stroke-width: 2;
  fill: rgba(168,85,247,0.15);
}
.label-text {
  fill: #ccc;
  transition: fill 0.2s;
  user-select: none;
}
.label-text.active {
  fill: #fff;
}
</style>
