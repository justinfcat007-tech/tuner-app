<template>
  <Transition name="toast">
    <div v-if="visible" :class="['toast', `toast--${type}`]" role="alert" aria-live="polite">
      {{ message }}
    </div>
  </Transition>
</template>

<script setup lang="ts">
import { ref } from 'vue'

type ToastType = 'info' | 'success' | 'error'

const visible = ref(false)
const message = ref('')
const type = ref<ToastType>('info')
let timer: ReturnType<typeof setTimeout> | null = null

function show(msg: string, t: ToastType = 'info', duration = 3000) {
  if (timer) clearTimeout(timer)
  message.value = msg
  type.value = t
  visible.value = true
  timer = setTimeout(() => { visible.value = false }, duration)
}

function hide() {
  visible.value = false
}

defineExpose({ show, hide })
</script>

<style scoped>
.toast {
  position: fixed;
  bottom: 80px;
  left: 50%;
  transform: translateX(-50%);
  padding: 12px 24px;
  border-radius: var(--radius-sm, 10px);
  font-size: 14px;
  font-weight: 500;
  color: #fff;
  z-index: 200;
  max-width: 320px;
  text-align: center;
  pointer-events: none;
}
.toast--info { background: #314050; }
.toast--success { background: #63C79A; color: #1A222C; }
.toast--error { background: #E97979; }

.toast-enter-active, .toast-leave-active {
  transition: opacity 150ms var(--motion-easing, cubic-bezier(0.2, 0.8, 0.2, 1));
}
.toast-enter-from, .toast-leave-to { opacity: 0; }
</style>
