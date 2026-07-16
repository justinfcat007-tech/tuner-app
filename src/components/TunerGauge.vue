<template>
  <div class="gauge-container">
    <svg viewBox="0 0 300 180" class="gauge-svg">
      <!-- Background arc -->
      <path :d="arcPath(180, 0, 180)" fill="none" stroke="#1e293b" stroke-width="12" stroke-linecap="round"/>
      
      <!-- Zone indicators -->
      <path :d="arcPath(180, 70, 110)" fill="none" stroke="#ef4444" stroke-width="10" stroke-linecap="round" opacity="0.6"/>
      <path :d="arcPath(180, 80, 100)" fill="none" stroke="#f59e0b" stroke-width="10" stroke-linecap="round" opacity="0.6"/>
      <path :d="arcPath(180, 87, 93)" fill="none" stroke="#22c55e" stroke-width="10" stroke-linecap="round" opacity="0.8"/>

      <!-- Tick marks -->
      <g v-for="i in 11" :key="i">
        <line 
          :x1="150 + 110 * Math.cos(angleForTick(i-1))" 
          :y1="160 + 110 * Math.sin(angleForTick(i-1))"
          :x2="150 + 120 * Math.cos(angleForTick(i-1))" 
          :y2="160 + 120 * Math.sin(angleForTick(i-1))"
          stroke="#64748b" stroke-width="2"/>
      </g>

      <!-- Needle -->
      <g :transform="`rotate(${needleAngle}, 150, 160)`" class="needle">
        <line x1="150" y1="160" x2="150" y2="55" stroke="#f8fafc" stroke-width="3" stroke-linecap="round"/>
        <circle cx="150" cy="160" r="8" fill="#f8fafc"/>
      </g>

      <!-- Center glow when in tune -->
      <circle v-if="inTune" cx="150" cy="160" r="12" fill="#22c55e" opacity="0.6">
        <animate attributeName="r" values="12;18;12" dur="1s" repeatCount="indefinite"/>
        <animate attributeName="opacity" values="0.6;0.3;0.6" dur="1s" repeatCount="indefinite"/>
      </circle>

      <!-- Labels -->
      <text x="30" y="170" fill="#ef4444" font-size="12" text-anchor="middle">♭</text>
      <text x="150" y="15" fill="#22c55e" font-size="12" text-anchor="middle">✓</text>
      <text x="270" y="170" fill="#ef4444" font-size="12" text-anchor="middle">♯</text>
    </svg>

    <!-- Digital display -->
    <div class="digital-display">
      <div class="note-display" :class="{ 'in-tune': inTune }">
        {{ note || '--' }}
      </div>
      <div class="freq-display" v-if="frequency">
        {{ frequency.toFixed(1) }} Hz
      </div>
      <div class="cents-display" :class="centsClass">
        {{ centsDisplay }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  note: string
  frequency: number
  cents: number
  inTune: boolean
}>()

function arcPath(r: number, startDeg: number, endDeg: number): string {
  const cx = 150, cy = 160
  const startRad = (startDeg * Math.PI) / 180
  const endRad = (endDeg * Math.PI) / 180
  const x1 = cx + r * Math.cos(startRad)
  const y1 = cy + r * Math.sin(startRad)
  const x2 = cx + r * Math.cos(endRad)
  const y2 = cy + r * Math.sin(endRad)
  const largeArc = endDeg - startDeg > 180 ? 1 : 0
  return `M ${x1} ${y1} A ${r} ${r} 0 ${largeArc} 1 ${x2} ${y2}`
}

function angleForTick(i: number): number {
  return Math.PI + (i / 10) * Math.PI
}

const needleAngle = computed(() => {
  const clamped = Math.max(-50, Math.min(50, props.cents))
  return (clamped / 50) * 90
})

const centsDisplay = computed(() => {
  if (!props.frequency) return '-- cents'
  const sign = props.cents >= 0 ? '+' : ''
  return `${sign}${props.cents} cents`
})

const centsClass = computed(() => ({
  'in-tune': props.inTune,
  'sharp': props.cents > 5,
  'flat': props.cents < -5,
}))
</script>

<style scoped>
.gauge-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

.gauge-svg {
  width: 100%;
  max-width: 360px;
  height: auto;
}

.needle {
  transition: transform 0.1s ease-out;
}

.digital-display {
  text-align: center;
  margin-top: 16px;
}

.note-display {
  font-size: 64px;
  font-weight: 700;
  color: #94a3b8;
  transition: color 0.3s;
  line-height: 1;
}

.note-display.in-tune {
  color: #22c55e;
  text-shadow: 0 0 20px rgba(34, 197, 94, 0.5);
}

.freq-display {
  font-size: 18px;
  color: #64748b;
  margin-top: 4px;
}

.cents-display {
  font-size: 20px;
  font-weight: 600;
  margin-top: 8px;
  transition: color 0.3s;
  color: #64748b;
}

.cents-display.in-tune {
  color: #22c55e;
}

.cents-display.sharp {
  color: #ef4444;
}

.cents-display.flat {
  color: #f59e0b;
}
</style>
