<template>
  <svg viewBox="0 0 360 430" class="guitar-svg" role="img" aria-label="可选择琴弦的原声吉他">
    <defs>
      <linearGradient id="guitar-headstock-wood" x1="0" y1="0" x2="1" y2="1">
        <stop offset="0" stop-color="#e0b869" />
        <stop offset="0.28" stop-color="#a9652f" />
        <stop offset="0.65" stop-color="#6c3519" />
        <stop offset="1" stop-color="#3d1c10" />
      </linearGradient>
      <linearGradient id="guitar-neck-wood" x1="0" y1="0" x2="1" y2="0">
        <stop offset="0" stop-color="#21100a" />
        <stop offset="0.5" stop-color="#5a2e17" />
        <stop offset="1" stop-color="#21100a" />
      </linearGradient>
      <radialGradient id="guitar-body-wood" cx="33%" cy="25%">
        <stop offset="0" stop-color="#f8d489" />
        <stop offset="0.45" stop-color="#d89346" />
        <stop offset="0.78" stop-color="#9e4c24" />
        <stop offset="1" stop-color="#5d2415" />
      </radialGradient>
      <linearGradient id="guitar-metal" x1="0" y1="0" x2="1" y2="1">
        <stop offset="0" stop-color="#fff" />
        <stop offset="0.25" stop-color="#bfc5c7" />
        <stop offset="0.6" stop-color="#6d7478" />
        <stop offset="1" stop-color="#e5e8e8" />
      </linearGradient>
      <pattern id="guitar-grain" width="10" height="34" patternUnits="userSpaceOnUse">
        <path d="M2 0C6 8 0 18 5 34M8 0C3 12 10 20 7 34" fill="none" stroke="#5f2917" stroke-width="0.75" opacity="0.22" />
      </pattern>
      <filter id="guitar-shadow" x="-30%" y="-20%" width="160%" height="150%">
        <feDropShadow dx="0" dy="3" stdDeviation="2.5" flood-color="#000" flood-opacity="0.38" />
      </filter>
      <filter id="guitar-soft-shadow" x="-30%" y="-30%" width="160%" height="160%">
        <feDropShadow dx="0" dy="1" stdDeviation="1" flood-color="#000" flood-opacity="0.42" />
      </filter>
      <clipPath id="guitar-headstock-clip">
        <path d="M130 27C117 30 111 40 111 53v88c0 18 12 35 31 42h76c19-7 31-24 31-42V53c0-13-6-23-19-26-16-5-28-10-50-10s-34 5-50 10Z" />
      </clipPath>
    </defs>

    <!-- 原声吉他琴身：保留在下方作为真实造型提示，不影响琴头操作。 -->
    <g filter="url(#guitar-shadow)">
      <path d="M143 287c-22 12-31 34-24 54 4 13 14 23 27 29-25 12-34 41-17 59 13 14 34 16 51 8 17 8 38 6 51-8 17-18 8-47-17-59 13-6 23-16 27-29 7-20-2-42-24-54-17-9-39-10-57 0Z" fill="url(#guitar-body-wood)" stroke="#542312" stroke-width="3" />
      <path d="M143 287c-22 12-31 34-24 54 4 13 14 23 27 29-25 12-34 41-17 59 13 14 34 16 51 8 17 8 38 6 51-8 17-18 8-47-17-59 13-6 23-16 27-29 7-20-2-42-24-54-17-9-39-10-57 0Z" fill="url(#guitar-grain)" opacity="0.62" />
      <ellipse cx="180" cy="344" rx="29" ry="24" fill="#26130d" stroke="#f0c272" stroke-width="5" />
      <ellipse cx="180" cy="344" rx="34" ry="29" fill="none" stroke="#75341e" stroke-width="2" opacity="0.8" />
      <rect x="149" y="375" width="62" height="9" rx="2" fill="#35170e" />
      <circle cx="180" cy="344" r="21" fill="none" stroke="#d59644" stroke-width="1.2" opacity="0.7" />
    </g>

    <!-- 琴颈与指板 -->
    <path d="M151 173h58l14 127h-86l14-127Z" fill="#7a3d20" stroke="#44200f" stroke-width="2" />
    <path d="M159 178h42l10 122h-62l10-122Z" fill="url(#guitar-neck-wood)" />
    <g stroke="#d7c49b" stroke-width="1.35" opacity="0.78">
      <line x1="154" y1="210" x2="206" y2="210" />
      <line x1="152" y1="234" x2="208" y2="234" />
      <line x1="150" y1="256" x2="210" y2="256" />
      <line x1="149" y1="277" x2="211" y2="277" />
    </g>
    <circle cx="180" cy="222" r="2.6" fill="#e4d5ad" opacity="0.7" />
    <circle cx="180" cy="267" r="2.6" fill="#e4d5ad" opacity="0.7" />

    <!-- 3+3 民谣吉他琴头 -->
    <g filter="url(#guitar-shadow)">
      <path d="M130 27C117 30 111 40 111 53v88c0 18 12 35 31 42h76c19-7 31-24 31-42V53c0-13-6-23-19-26-16-5-28-10-50-10s-34 5-50 10Z" fill="url(#guitar-headstock-wood)" stroke="#3c1b0d" stroke-width="2.4" />
      <path d="M130 27C117 30 111 40 111 53v88c0 18 12 35 31 42h76c19-7 31-24 31-42V53c0-13-6-23-19-26-16-5-28-10-50-10s-34 5-50 10Z" fill="url(#guitar-grain)" clip-path="url(#guitar-headstock-clip)" />
      <path d="M130 36c15-9 31-13 50-13s35 4 50 13" fill="none" stroke="#f5d48a" stroke-width="1.1" opacity="0.55" />
      <path d="M145 52c12-8 58-8 70 0v91c-17 11-53 11-70 0V52Z" fill="#36170e" opacity="0.64" />
      <text x="180" y="111" text-anchor="middle" fill="#e8c77b" font-size="15" font-family="Georgia, serif" font-weight="700" letter-spacing="2">TUNER</text>
    </g>
    <rect x="140" y="178" width="80" height="7" rx="2" fill="#efe0bd" stroke="#9d8050" stroke-width="1" />

    <!-- 六根弦从琴头延续到琴桥。 -->
    <g fill="none" stroke-linecap="round">
      <path v-for="string in strings" :key="string.id" :d="string.path" :stroke="string.color" :stroke-width="string.width" opacity="0.85" />
    </g>

    <!-- 左侧弦钮：4、5、6 弦 -->
    <g v-for="peg in leftPegs" :key="peg.num" class="peg-control" @click="$emit('select', peg.num)">
      <rect x="98" :y="peg.y - 3" width="29" height="6" rx="2" fill="url(#guitar-metal)" stroke="#565d60" stroke-width="0.8" />
      <path d="M86 0h17c5 0 8 4 8 9s-3 9-8 9H86c-5 0-8-4-8-9s3-9 8-9Z" :transform="`translate(0 ${peg.y - 9})`" fill="url(#guitar-metal)" stroke="#565d60" stroke-width="0.8" />
      <circle cx="130" :cy="peg.y" r="7" fill="url(#guitar-metal)" stroke="#555" stroke-width="0.9" filter="url(#guitar-soft-shadow)" />
      <circle cx="130" :cy="peg.y" r="2" fill="#4c5356" />
      <text x="69" :y="peg.y + 5" text-anchor="end" class="note-text" :aria-label="`第 ${peg.num} 弦音名，点击更改`" @click.stop="$emit('changeNote', peg.num)">{{ formatNote(getNote(peg.num)) }}</text>
      <rect x="75" :y="peg.y - 13" width="25" height="26" rx="7" :class="['num-bg', { active: activePeg === peg.num }]" />
      <text x="87.5" :y="peg.y + 5" text-anchor="middle" :class="['num-text', { active: activePeg === peg.num }]">{{ peg.num }}</text>
    </g>

    <!-- 右侧弦钮：3、2、1 弦 -->
    <g v-for="peg in rightPegs" :key="peg.num" class="peg-control" @click="$emit('select', peg.num)">
      <rect x="233" :y="peg.y - 3" width="29" height="6" rx="2" fill="url(#guitar-metal)" stroke="#565d60" stroke-width="0.8" />
      <path d="M0 0h17c5 0 8 4 8 9s-3 9-8 9H0c-5 0-8-4-8-9s3-9 8-9Z" :transform="`translate(257 ${peg.y - 9})`" fill="url(#guitar-metal)" stroke="#565d60" stroke-width="0.8" />
      <circle cx="230" :cy="peg.y" r="7" fill="url(#guitar-metal)" stroke="#555" stroke-width="0.9" filter="url(#guitar-soft-shadow)" />
      <circle cx="230" :cy="peg.y" r="2" fill="#4c5356" />
      <rect x="260" :y="peg.y - 13" width="25" height="26" rx="7" :class="['num-bg', { active: activePeg === peg.num }]" />
      <text x="272.5" :y="peg.y + 5" text-anchor="middle" :class="['num-text', { active: activePeg === peg.num }]">{{ peg.num }}</text>
      <text x="291" :y="peg.y + 5" text-anchor="start" class="note-text" :aria-label="`第 ${peg.num} 弦音名，点击更改`" @click.stop="$emit('changeNote', peg.num)">{{ formatNote(getNote(peg.num)) }}</text>
    </g>
  </svg>
</template>

<script setup lang="ts">
const props = defineProps<{
  activePeg?: number
  stringNotes?: string[]
}>()

defineEmits<{ select: [n: number]; changeNote: [n: number] }>()

const leftPegs = [
  { num: 4, y: 69 },
  { num: 5, y: 111 },
  { num: 6, y: 151 },
]
const rightPegs = [
  { num: 3, y: 69 },
  { num: 2, y: 111 },
  { num: 1, y: 151 },
]

const strings = [
  { id: 6, path: 'M130 151 L164 183 L169 376', width: 2.1, color: '#c5b67b' },
  { id: 5, path: 'M130 111 L171 183 L174 376', width: 1.75, color: '#c7c7bd' },
  { id: 4, path: 'M130 69 L177 183 L178 376', width: 1.45, color: '#d4d0bd' },
  { id: 3, path: 'M230 69 L183 183 L182 376', width: 1.2, color: '#e8e2c9' },
  { id: 2, path: 'M230 111 L189 183 L186 376', width: 1, color: '#efe9d7' },
  { id: 1, path: 'M230 151 L196 183 L191 376', width: 0.8, color: '#fff9e7' },
]

function getNote(num: number): string {
  return props.stringNotes?.[num - 1] || '--'
}

function formatNote(note: string): string {
  return note.replace('#', '♯').replace('b', '♭')
}
</script>

<style scoped>
.guitar-svg {
  display: block;
  width: 100%;
  max-width: 360px;
  height: auto;
}

.peg-control { cursor: pointer; }
.peg-control:hover .num-bg { stroke: #d9a74c; }

.num-bg {
  fill: #1d2022;
  stroke: #5f6769;
  stroke-width: 1.25;
  transition: fill 0.2s, stroke 0.2s;
}
.num-bg.active { fill: #6c3d1e; stroke: #ffd071; stroke-width: 2; }
.num-text { fill: #d7dadd; font-size: 13px; font-weight: 700; pointer-events: none; }
.num-text.active { fill: #fff7db; }
.note-text { fill: #fff4d3; font-size: 16px; font-weight: 700; cursor: pointer; user-select: none; }
.note-text:hover { fill: #ffd071; }
</style>
