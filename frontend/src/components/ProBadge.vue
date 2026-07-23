<template>
  <button
    :class="['pro-badge', { compact }]"
    @click="$router.push('/pro')"
    aria-label="Tuner Pro"
  >
    PRO
  </button>
</template>

<script setup lang="ts">
defineProps<{ compact?: boolean }>()
</script>

<style scoped>
.pro-badge {
  display: inline-flex;
  align-items: center;
  padding: 6px 16px;
  border: 1.5px solid var(--color-accent, #E7B65C);
  border-radius: var(--radius-pill, 999px);
  background: transparent;
  color: var(--color-accent, #E7B65C);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 1px;
  cursor: pointer;
  transition: all var(--motion-fast, 150ms) var(--motion-easing, cubic-bezier(0.2, 0.8, 0.2, 1));
}
.pro-badge:hover {
  background: var(--color-accent, #E7B65C);
  color: var(--color-ink, #1A222C);
}
.compact {
  padding: 4px 12px;
  font-size: 11px;
}
</style>
