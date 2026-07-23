<template>
  <div class="profile-page">
    <header class="profile-header">
      <button class="profile-back" @click="$router.back()" aria-label="Go back">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M15 18l-6-6 6-6"/>
        </svg>
      </button>
      <h1 class="profile-title">Profile</h1>
    </header>

    <div class="profile-content">
      <!-- Plan status -->
      <div class="profile-card">
        <div class="profile-plan-label">
          {{ isPro ? 'Tuner Pro' : 'Free plan' }}
        </div>
        <p class="profile-plan-desc" v-if="!isPro">
          Unlock custom tunings, more instruments, and ad-free practice.
        </p>
        <button v-if="!isPro" class="profile-cta" @click="$router.push('/pro')">
          Explore Tuner Pro
        </button>
        <div v-else class="profile-pro-details">
          <p>No ads · Custom tunings · More instruments</p>
          <button class="profile-manage" @click="onManage">Manage subscription</button>
        </div>
      </div>

      <!-- Settings list -->
      <div class="profile-list">
        <button v-for="item in listItems" :key="item.id" class="profile-list-item" @click="onItemClick(item)">
          <span>{{ item.label }}</span>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M9 18l6-6-6-6"/>
          </svg>
        </button>
      </div>

      <button class="profile-restore" @click="onRestore">Restore purchase</button>
      <button class="profile-delete" @click="onDeleteAccount">Delete account</button>
    </div>

    <!-- Delete confirmation -->
    <div v-if="showDeleteConfirm" class="profile-overlay" @click="showDeleteConfirm = false">
      <div class="profile-modal" @click.stop>
        <h3>Delete account?</h3>
        <p>This action cannot be undone. All your data will be permanently removed.</p>
        <div class="profile-modal-actions">
          <button class="profile-modal-cancel" @click="showDeleteConfirm = false">Cancel</button>
          <button class="profile-modal-delete" @click="confirmDelete">Delete</button>
        </div>
      </div>
    </div>

    <ToastMessage ref="toastRef" />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import ToastMessage from '../components/ToastMessage.vue'
import { getBillingAdapter } from '../services/billing'

const toastRef = ref<InstanceType<typeof ToastMessage>>()
const showDeleteConfirm = ref(false)

// 首轮默认 free
const isPro = ref(false)

const listItems = [
  { id: 'privacy', label: 'Privacy policy', action: 'link' },
  { id: 'terms', label: 'Terms of use', action: 'link' },
  { id: 'feedback', label: 'Send feedback', action: 'mailto' },
]

function onItemClick(item: { id: string; action: string }) {
  if (item.action === 'link') {
    // 使用真实路由或外链常量
    if (item.id === 'privacy') window.location.href = '/privacy'
    if (item.id === 'terms') window.location.href = '/terms'
  }
  if (item.action === 'mailto') {
    window.location.href = 'mailto:support@tunerapp.example'
  }
}

async function onRestore() {
  const adapter = getBillingAdapter({ show: (m: string) => toastRef.value?.show(m, 'info') })
  await adapter.restore()
}

async function onManage() {
  const adapter = getBillingAdapter({ show: (m: string) => toastRef.value?.show(m, 'info') })
  await adapter.restore()
}

function onDeleteAccount() {
  showDeleteConfirm.value = true
}

function confirmDelete() {
  showDeleteConfirm.value = false
  toastRef.value?.show('Account deletion is not yet implemented.', 'info')
}
</script>

<style scoped>
.profile-page {
  background: var(--color-canvas, #10151D);
  min-height: 100vh;
  color: var(--color-text-primary, #F8FAFC);
  max-width: 480px;
  margin: 0 auto;
}
.profile-header {
  display: flex; align-items: center; gap: 16px; padding: 16px;
}
.profile-back {
  width: 44px; height: 44px;
  background: none; border: none;
  color: var(--color-text-primary, #F8FAFC);
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  border-radius: 50%;
  transition: background var(--motion-fast, 150ms);
}
.profile-back:hover { background: rgba(255,255,255,0.08); }
.profile-title { font-family: var(--font-display, Georgia); font-size: var(--size-title, 24px); margin: 0; }
.profile-content { padding: 0 16px 48px; }

.profile-card {
  background: var(--color-surface, #18212C);
  border: 1.5px solid var(--color-border, #314050);
  border-radius: var(--radius-md, 16px);
  padding: 20px;
  margin-bottom: 24px;
}
.profile-plan-label {
  font-size: var(--size-body-large, 17px);
  font-weight: 700;
  margin-bottom: 8px;
}
.profile-plan-desc {
  font-size: var(--size-body, 15px);
  color: var(--color-text-secondary, #B8C2CC);
  margin: 0 0 16px;
  line-height: var(--lh-normal, 1.45);
}
.profile-cta {
  display: block; width: 100%;
  padding: 12px;
  background: var(--color-accent, #E7B65C);
  color: var(--color-ink, #1A222C);
  border: none; border-radius: var(--radius-sm, 10px);
  font-size: 15px; font-weight: 600; cursor: pointer;
  transition: background var(--motion-fast, 150ms);
}
.profile-cta:hover { background: var(--color-accent-strong, #C98B32); }

.profile-pro-details p {
  font-size: var(--size-body, 15px);
  color: var(--color-text-secondary, #B8C2CC);
  margin: 0 0 12px;
}
.profile-manage {
  background: none; border: 1.5px solid var(--color-border, #314050);
  color: var(--color-text-primary, #F8FAFC);
  padding: 10px 16px; border-radius: var(--radius-sm, 10px);
  font-size: 14px; cursor: pointer;
  transition: border-color var(--motion-fast, 150ms);
}
.profile-manage:hover { border-color: var(--color-border-strong, #4A5D70); }

.profile-list {
  background: var(--color-surface, #18212C);
  border-radius: var(--radius-md, 16px);
  overflow: hidden;
  margin-bottom: 24px;
}
.profile-list-item {
  display: flex; justify-content: space-between; align-items: center;
  width: 100%; padding: 16px 20px;
  background: none; border: none; border-bottom: 1px solid var(--color-border, #314050);
  color: var(--color-text-primary, #F8FAFC);
  font-size: var(--size-body, 15px); cursor: pointer;
  transition: background var(--motion-fast, 150ms);
}
.profile-list-item:last-child { border-bottom: none; }
.profile-list-item:hover { background: var(--color-surface-raised, #202C39); }

.profile-restore {
  display: block; width: 100%;
  padding: 12px;
  background: transparent; color: var(--color-text-secondary, #B8C2CC);
  border: none; font-size: 14px; cursor: pointer;
  transition: color var(--motion-fast, 150ms);
  margin-bottom: 8px;
}
.profile-restore:hover { color: var(--color-text-primary, #F8FAFC); }

.profile-delete {
  display: block; width: 100%;
  padding: 12px;
  background: transparent; color: var(--color-danger, #E97979);
  border: none; font-size: 14px; cursor: pointer;
  transition: opacity var(--motion-fast, 150ms);
}
.profile-delete:hover { opacity: 0.8; }

.profile-overlay {
  position: fixed; inset: 0;
  background: var(--color-overlay, rgba(5,10,16,0.48));
  display: flex; align-items: center; justify-content: center;
  z-index: 150;
}
.profile-modal {
  background: var(--color-surface-raised, #202C39);
  border-radius: var(--radius-md, 16px);
  padding: 24px;
  max-width: 320px; width: 90%;
  color: var(--color-text-primary, #F8FAFC);
}
.profile-modal h3 { margin: 0 0 12px; font-size: 18px; }
.profile-modal p { margin: 0 0 20px; font-size: 14px; color: var(--color-text-secondary, #B8C2CC); line-height: 1.5; }
.profile-modal-actions { display: flex; gap: 12px; }
.profile-modal-cancel {
  flex: 1; padding: 10px;
  background: var(--color-surface, #18212C);
  border: 1px solid var(--color-border, #314050);
  border-radius: var(--radius-sm, 10px);
  color: var(--color-text-primary, #F8FAFC);
  font-size: 14px; cursor: pointer;
}
.profile-modal-delete {
  flex: 1; padding: 10px;
  background: var(--color-danger, #E97979);
  border: none; border-radius: var(--radius-sm, 10px);
  color: #fff; font-size: 14px; font-weight: 600; cursor: pointer;
}
</style>
