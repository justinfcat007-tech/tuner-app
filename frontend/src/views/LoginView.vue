<template>
  <div class="login-page">
    <div class="login-card">
      <h1 class="title">🎶 调音器</h1>
      <p class="subtitle">扬琴 · 吉他 · 尤克里里</p>

      <div class="tabs">
        <button :class="{ active: mode === 'login' }" @click="mode = 'login'">登录</button>
        <button :class="{ active: mode === 'register' }" @click="mode = 'register'">注册</button>
      </div>

      <form @submit.prevent="handleSubmit" class="form">
        <div class="input-group">
          <label>用户名</label>
          <input v-model="form.username" type="text" placeholder="请输入用户名" required />
        </div>

        <div v-if="mode === 'register'" class="input-group">
          <label>邮箱</label>
          <input v-model="form.email" type="email" placeholder="请输入邮箱" />
        </div>

        <div class="input-group">
          <label>密码</label>
          <input v-model="form.password" type="password" placeholder="请输入密码" required />
        </div>

        <div v-if="error" class="error">{{ error }}</div>

        <button type="submit" class="submit-btn" :disabled="loading">
          {{ loading ? '处理中...' : (mode === 'login' ? '登 录' : '注 册') }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { authAPI } from '../api'

const router = useRouter()
const mode = ref<'login' | 'register'>('login')
const loading = ref(false)
const error = ref('')

const form = reactive({
  username: '',
  email: '',
  password: '',
})

async function handleSubmit() {
  error.value = ''
  loading.value = true

  try {
    let res: any
    if (mode.value === 'login') {
      res = await authAPI.login({ username: form.username, password: form.password })
    } else {
      if (!form.email) { error.value = '请填写邮箱'; loading.value = false; return }
      res = await authAPI.register({ username: form.username, email: form.email, password: form.password })
    }

    if (res.code === 0) {
      localStorage.setItem('token', res.data.token)
      localStorage.setItem('user', JSON.stringify(res.data.user))
      router.push('/')
    } else {
      error.value = res.message || '操作失败'
    }
  } catch (e: any) {
    error.value = e.response?.data?.message || '网络错误'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.login-card {
  background: #1e293b;
  border-radius: 20px;
  padding: 40px;
  width: 100%;
  max-width: 400px;
  border: 1px solid #334155;
}

.title {
  text-align: center;
  font-size: 32px;
  color: #f1f5f9;
  margin: 0;
}

.subtitle {
  text-align: center;
  color: #64748b;
  font-size: 14px;
  margin: 4px 0 24px;
}

.tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 24px;
}

.tabs button {
  flex: 1;
  padding: 10px;
  background: #334155;
  border: 2px solid transparent;
  border-radius: 10px;
  color: #94a3b8;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.tabs button.active {
  border-color: #3b82f6;
  color: #f1f5f9;
  background: #1e3a8a;
}

.form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.input-group label {
  display: block;
  color: #94a3b8;
  font-size: 13px;
  margin-bottom: 6px;
}

.input-group input {
  width: 100%;
  padding: 12px 16px;
  background: #0f172a;
  border: 2px solid #334155;
  border-radius: 10px;
  color: #f1f5f9;
  font-size: 15px;
  outline: none;
  transition: border-color 0.2s;
}

.input-group input:focus {
  border-color: #3b82f6;
}

.error {
  color: #ef4444;
  font-size: 13px;
  text-align: center;
}

.submit-btn {
  padding: 14px;
  background: #3b82f6;
  border: none;
  border-radius: 10px;
  color: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  margin-top: 8px;
}

.submit-btn:hover:not(:disabled) {
  background: #2563eb;
  transform: translateY(-1px);
}

.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
