<template>
  <div class="tuning-meter">
    <span class="meter-label">低</span>
    <div class="meter-track">
      <!-- 刻度线 -->
      <svg class="ticks-svg" viewBox="0 0 300 30" preserveAspectRatio="none">
        <!-- 左侧白粗线 -->
        <line x1="0" y1="2" x2="0" y2="28" stroke="#fff" stroke-width="2"/>
        <!-- 右侧白粗线 -->
        <line x1="300" y1="2" x2="300" y2="28" stroke="#fff" stroke-width="2"/>

        <!-- 中心线 -->
        <line x1="150" y1="4" x2="150" y2="26" stroke="#ccc" stroke-width="2"/>

        <!-- 左侧15个刻度 (从中心150往左到10) -->
        <line v-for="i in 15" :key="'l'+i"
          :x1="150 - i * step" :y1="i % 5 === 0 ? 8 : 12"
          :x2="150 - i * step" :y2="22"
          :stroke="i % 5 === 0 ? '#bbb' : '#777'"
          :stroke-width="i % 5 === 0 ? 1.5 : 1"/>

        <!-- 右侧15个刻度 (从中心150往右到290) -->
        <line v-for="i in 15" :key="'r'+i"
          :x1="150 + i * step" :y1="i % 5 === 0 ? 8 : 12"
          :x2="150 + i * step" :y2="22"
          :stroke="i % 5 === 0 ? '#bbb' : '#777'"
          :stroke-width="i % 5 === 0 ? 1.5 : 1"/>
      </svg>

      <!-- 滑块 -->
      <div
        class="slider-indicator"
        :style="{ left: sliderPosition + '%' }"
      >
        <div class="slider-arrow"></div>
        <div class="slider-block"></div>
      </div>
    </div>
    <span class="meter-label">高</span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  cents: number
}>()

const step = 140 / 15  // 每格间距

const sliderPosition = computed(() => {
  const clamped = Math.max(-50, Math.min(50, props.cents))
  return ((clamped + 50) / 100) * 100
})
</script>

<style scoped>
.tuning-meter {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 20px 12px 10px;
}

.meter-label {
  font-size: 14px;
  color: #888;
  white-space: nowrap;
  flex-shrink: 0;
}

.meter-track {
  flex: 1;
  max-width: 340px;
  height: 30px;
  position: relative;
}

.ticks-svg {
  width: 100%;
  height: 100%;
  display: block;
}

.slider-indicator {
  position: absolute;
  top: 0;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  transition: left 0.15s ease-out;
  z-index: 2;
  height: 100%;
  justify-content: flex-start;
}

.slider-arrow {
  width: 0;
  height: 0;
  border-left: 6px solid transparent;
  border-right: 6px solid transparent;
  border-top: 6px solid #fff;
}

.slider-block {
  width: 20px;
  flex: 1;
  max-height: 26px;
  background: rgba(120, 120, 120, 0.3);
  border-radius: 2px;
  border: 1px solid rgba(180, 180, 180, 0.25);
}
</style>
