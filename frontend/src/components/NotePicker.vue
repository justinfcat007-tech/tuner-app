<template>
  <div class="note-picker">
    <div class="picker-track" ref="trackRef" @touchstart="onTouchStart" @touchmove="onTouchMove" @touchend="onTouchEnd" @mousedown="onMouseDown" @mousemove="onMouseMove" @mouseup="onMouseUp" @mouseleave="onMouseUp">
      <div
        v-for="(note, i) in notes"
        :key="note"
        :class="['picker-item', { active: i === activeIndex }]"
        :ref="el => { if (el) itemRefs[i] = el as HTMLElement }"
        @click="scrollToIndex(i)"
      >
        {{ note }}
      </div>
    </div>
    <div class="picker-highlight"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, nextTick } from 'vue'

const props = defineProps<{
  notes: string[]
  modelValue: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const trackRef = ref<HTMLElement>()
const itemRefs: Record<number, HTMLElement> = {}
const activeIndex = ref(0)
const ITEM_HEIGHT = 40

// 初始化 activeIndex
onMounted(() => {
  const idx = props.notes.indexOf(props.modelValue)
  if (idx >= 0) {
    activeIndex.value = idx
    nextTick(() => scrollToIndex(idx, false))
  }
})

watch(() => props.modelValue, (val) => {
  const idx = props.notes.indexOf(val)
  if (idx >= 0 && idx !== activeIndex.value) {
    activeIndex.value = idx
    nextTick(() => scrollToIndex(idx, false))
  }
})

function scrollToIndex(idx: number, animate = true) {
  if (!trackRef.value) return
  const offset = idx * ITEM_HEIGHT
  trackRef.value.scrollTo({
    top: offset,
    behavior: animate ? 'smooth' : 'auto',
  })
}

// 滚动时更新 activeIndex
function onScroll() {
  if (!trackRef.value) return
  const scrollTop = trackRef.value.scrollTop
  const idx = Math.round(scrollTop / ITEM_HEIGHT)
  const clamped = Math.max(0, Math.min(props.notes.length - 1, idx))
  if (clamped !== activeIndex.value) {
    activeIndex.value = clamped
    emit('update:modelValue', props.notes[clamped])
  }
}

onMounted(() => {
  if (trackRef.value) {
    trackRef.value.addEventListener('scroll', onScroll, { passive: true })
  }
})

// 拖拽支持
let dragging = false
let startY = 0
let startScrollTop = 0

function onTouchStart(e: TouchEvent) {
  dragging = true
  startY = e.touches[0].clientY
  startScrollTop = trackRef.value?.scrollTop || 0
}
function onTouchMove(e: TouchEvent) {
  if (!dragging || !trackRef.value) return
  const dy = e.touches[0].clientY - startY
  trackRef.value.scrollTop = startScrollTop - dy
}
function onTouchEnd() {
  dragging = false
  snapToNearest()
}
function onMouseDown(e: MouseEvent) {
  dragging = true
  startY = e.clientY
  startScrollTop = trackRef.value?.scrollTop || 0
}
function onMouseMove(e: MouseEvent) {
  if (!dragging || !trackRef.value) return
  const dy = e.clientY - startY
  trackRef.value.scrollTop = startScrollTop - dy
}
function onMouseUp() {
  if (dragging) {
    dragging = false
    snapToNearest()
  }
}

function snapToNearest() {
  if (!trackRef.value) return
  const scrollTop = trackRef.value.scrollTop
  const idx = Math.round(scrollTop / ITEM_HEIGHT)
  scrollToIndex(Math.max(0, Math.min(props.notes.length - 1, idx)))
}
</script>

<style scoped>
.note-picker {
  position: relative;
  height: 120px;
  overflow: hidden;
  border-radius: 8px;
  background: #1a1a1a;
  border: 1px solid #333;
}

.picker-track {
  height: 100%;
  overflow-y: auto;
  scroll-snap-type: y mandatory;
  -webkit-overflow-scrolling: touch;
  padding: 40px 0;
  scrollbar-width: none;
}
.picker-track::-webkit-scrollbar {
  display: none;
}

.picker-item {
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 600;
  color: #666;
  scroll-snap-align: center;
  cursor: pointer;
  transition: color 0.15s, transform 0.15s;
  user-select: none;
}

.picker-item.active {
  color: #fff;
  font-size: 18px;
  font-weight: 700;
}

.picker-highlight {
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  height: 40px;
  transform: translateY(-50%);
  border-top: 1px solid rgba(168, 85, 247, 0.4);
  border-bottom: 1px solid rgba(168, 85, 247, 0.4);
  pointer-events: none;
  background: rgba(168, 85, 247, 0.06);
}
</style>
