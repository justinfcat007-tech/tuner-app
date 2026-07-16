<template>
  <div class="orders-page">
    <header class="page-header">
      <router-link to="/" class="back-link">← 返回调音器</router-link>
      <h1>📋 订单记录</h1>
    </header>

    <div v-if="loading" class="loading">加载中...</div>

    <div v-else-if="orders.length === 0" class="empty">
      <p>暂无订单记录</p>
      <router-link to="/vip" class="go-vip">去看看VIP套餐 →</router-link>
    </div>

    <div v-else class="orders-list">
      <div v-for="o in orders" :key="o.id" class="order-card">
        <div class="order-header">
          <span class="order-no">{{ o.order_no }}</span>
          <span :class="['order-status', statusClass(o.pay_status)]">
            {{ statusText(o.pay_status) }}
          </span>
        </div>
        <div class="order-body">
          <div class="order-product">{{ o.product_name }}</div>
          <div class="order-amount">¥{{ (o.amount / 100).toFixed(2) }}</div>
        </div>
        <div class="order-footer">
          <span class="order-channel">{{ channelText(o.pay_channel) }}</span>
          <span class="order-time">{{ formatTime(o.created_at) }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { payAPI, type Order } from '../api'

const orders = ref<Order[]>([])
const loading = ref(true)

onMounted(async () => {
  try {
    const res = await payAPI.orders()
    if (res.code === 0) orders.value = res.data
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
})

function statusText(s: number) {
  return ['待支付', '已支付', '已退款', '已关闭'][s] || '未知'
}

function statusClass(s: number) {
  return ['pending', 'paid', 'refunded', 'closed'][s] || ''
}

function channelText(ch: string) {
  const map: Record<string, string> = { alipay: '💙 支付宝', wechat: '💚 微信', stripe: '💳 Stripe' }
  return map[ch] || ch
}

function formatTime(t: string) {
  if (!t) return '--'
  return new Date(t).toLocaleString('zh-CN')
}
</script>

<style scoped>
.orders-page { max-width: 600px; margin: 0 auto; padding: 20px; }
.page-header { margin-bottom: 24px; }
.back-link { color: #64748b; text-decoration: none; font-size: 14px; }
.back-link:hover { color: #f1f5f9; }
.page-header h1 { color: #f1f5f9; margin: 8px 0 0; }

.loading { text-align: center; color: #64748b; padding: 40px; }
.empty { text-align: center; color: #64748b; padding: 40px; }
.go-vip { color: #3b82f6; text-decoration: none; }

.orders-list { display: flex; flex-direction: column; gap: 12px; }

.order-card {
  background: #1e293b;
  border: 1px solid #334155;
  border-radius: 12px;
  padding: 16px;
}

.order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
.order-no { color: #64748b; font-size: 12px; font-family: monospace; }
.order-status { font-size: 12px; font-weight: 600; padding: 2px 8px; border-radius: 6px; }
.order-status.pending { background: #854d0e; color: #fde68a; }
.order-status.paid { background: #166534; color: #86efac; }
.order-status.refunded { background: #7f1d1d; color: #fca5a5; }
.order-status.closed { background: #334155; color: #94a3b8; }

.order-body { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
.order-product { color: #f1f5f9; font-size: 15px; font-weight: 600; }
.order-amount { color: #f59e0b; font-size: 18px; font-weight: 700; }

.order-footer { display: flex; justify-content: space-between; }
.order-channel { color: #64748b; font-size: 12px; }
.order-time { color: #64748b; font-size: 12px; }
</style>
