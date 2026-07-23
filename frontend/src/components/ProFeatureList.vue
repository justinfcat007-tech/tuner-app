<template>
  <ul class="feature-list">
    <li v-for="(item, i) in items" :key="i" class="feature-item">
      <svg class="feature-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
        <path d="M20 6L9 17l-5-5"/>
      </svg>
      <span>{{ item }}</span>
    </li>
  </ul>
</template>

<script setup lang="ts">
defineProps<{ items: string[] }>()
</script>

<style scoped>
.feature-list {
  list-style: none;
  padding: 0;
  margin: 0 0 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.feature-item {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: var(--size-body, 15px);
  color: var(--color-text-primary, #F8FAFC);
}
.feature-icon {
  color: var(--color-accent, #E7B65C);
  flex-shrink: 0;
}
</style>
