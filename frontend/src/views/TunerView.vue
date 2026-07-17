<template>
  <div class="instrument-select-page">
    <!-- Header -->
    <header class="header">
      <h1 class="title">🎶 调音器</h1>
      <div class="header-right">
        <router-link to="/vip" class="vip-badge" v-if="userInfo">
          <span v-if="userInfo.vip_level > 0" class="vip-tag">VIP{{ userInfo.vip_level }}</span>
          <span v-else class="vip-tag free">升级VIP</span>
        </router-link>
        <span class="username" v-if="userInfo">{{ userInfo.nickname || userInfo.username }}</span>
      </div>
    </header>

    <!-- 乐器选择卡片 -->
    <div class="instrument-cards">
      <router-link to="/yangqin" class="inst-card yangqin">
        <span class="inst-emoji">🎵</span>
        <span class="inst-name">扬琴</span>
        <span class="inst-name-en">Yangqin</span>
      </router-link>
      <router-link to="/guitar" class="inst-card guitar">
        <span class="inst-emoji"></span>
        <span class="inst-name">吉他</span>
        <span class="inst-name-en">Guitar</span>
      </router-link>
      <router-link to="/ukulele" class="inst-card ukulele">
        <span class="inst-emoji">🪕</span>
        <span class="inst-name">尤克里里</span>
        <span class="inst-name-en">Ukulele</span>
      </router-link>
    </div>

    <footer class="footer">
      <p>基于 Web Audio API · 自动检测音高</p>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import type { UserInfo } from '../api'

const userInfo = ref<UserInfo | null>(null)

onMounted(() => {
  const u = localStorage.getItem('user')
  if (u) userInfo.value = JSON.parse(u)
})
</script>

<style scoped>
.instrument-select-page {
  padding: 20px 16px;
  min-height: 100vh;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 32px;
}

.title {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  margin: 0;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.vip-badge { text-decoration: none; }

.vip-tag {
  padding: 4px 10px;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #fff;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 700;
}

.vip-tag.free {
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
}

.username {
  color: #999;
  font-size: 14px;
}

.instrument-cards {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.inst-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px 24px;
  border-radius: 16px;
  text-decoration: none;
  transition: all 0.2s;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.inst-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
}

.inst-card.yangqin {
  background: linear-gradient(135deg, #f5f0e8, #ede5d8);
  border: 1px solid #e0d5c5;
}

.inst-card.guitar {
  background: linear-gradient(135deg, #1a1a2e, #16213e);
  border: 1px solid #2a2a4a;
}

.inst-card.ukulele {
  background: linear-gradient(135deg, #f0f4ff, #e8eeff);
  border: 1px solid #d0d8f0;
}

.inst-emoji {
  font-size: 36px;
}

.inst-name {
  font-size: 20px;
  font-weight: 700;
  flex: 1;
}

.inst-card.yangqin .inst-name { color: #5a4010; }
.inst-card.guitar .inst-name { color: #fff; }
.inst-card.ukulele .inst-name { color: #333; }

.inst-name-en {
  font-size: 13px;
}

.inst-card.yangqin .inst-name-en { color: #a08030; }
.inst-card.guitar .inst-name-en { color: #888; }
.inst-card.ukulele .inst-name-en { color: #8888bb; }

.footer {
  text-align: center;
  margin-top: 40px;
  padding: 20px;
  color: #bbb;
  font-size: 12px;
}
</style>
