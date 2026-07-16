<template>
  <div class="vip-page">
    <header class="page-header">
      <router-link to="/" class="back-link">← 返回调音器</router-link>
      <h1>👑 会员中心</h1>
    </header>

    <!-- 当前VIP状态 -->
    <div class="vip-status" v-if="userInfo">
      <div v-if="userInfo.vip_level > 0" class="vip-active">
        <span class="vip-level">VIP{{ userInfo.vip_level }}</span>
        <span class="vip-expire">有效期至 {{ formatDate(userInfo.vip_expire) }}</span>
      </div>
      <div v-else class="vip-free">
        <span>当前为免费用户</span>
        <p class="vip-desc">升级VIP解锁全部乐器和高级功能</p>
      </div>
    </div>

    <!-- 商品列表 -->
    <div class="products-grid" v-if="products.length">
      <div
        v-for="p in products"
        :key="p.id"
        :class="['product-card', { recommended: p.id === 'vip_yearly' }]"
      >
        <div v-if="p.id === 'vip_yearly'" class="recommend-tag">推荐</div>
        <h3 class="product-name">{{ p.name }}</h3>
        <div class="product-price">
          <span class="price-symbol">¥</span>
          <span class="price-amount">{{ (p.amount / 100).toFixed(0) }}</span>
        </div>
        <div class="product-desc">
          <span v-if="p.vip_days === 0">永久有效</span>
          <span v-else>{{ p.vip_days }}天</span>
          · VIP{{ p.vip_level }}
        </div>
        <div class="product-features">
          <div>✅ 全部乐器解锁</div>
          <div>✅ 高级调音模式</div>
          <div v-if="p.vip_level >= 2">✅ 自定义调弦方案</div>
          <div v-if="p.vip_level >= 2">✅ 导出调音报告</div>
        </div>
        <div class="pay-channels">
          <button
            v-for="ch in channels"
            :key="ch.id"
            class="pay-btn"
            :class="ch.id"
            @click="handlePay(p.id, ch.id)"
            :disabled="paying"
          >
            {{ ch.icon }} {{ ch.name }}
          </button>
        </div>
      </div>
    </div>

    <div v-if="loading" class="loading">加载中...</div>

    <!-- 订单记录入口 -->
    <div class="orders-link">
      <router-link to="/orders">📋 查看订单记录</router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { payAPI, type Product, type UserInfo } from '../api'

const products = ref<Product[]>([])
const loading = ref(true)
const paying = ref(false)
const userInfo = ref<UserInfo | null>(null)

const channels = [
  { id: 'alipay', name: '支付宝', icon: '💙' },
  { id: 'wechat', name: '微信支付', icon: '💚' },
]

onMounted(async () => {
  const u = localStorage.getItem('user')
  if (u) userInfo.value = JSON.parse(u)

  try {
    const res = await payAPI.products()
    if (res.code === 0) products.value = res.data
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
})

async function handlePay(productId: string, channel: string) {
  paying.value = true
  try {
    const res = await payAPI.createOrder(productId, channel)
    if (res.code === 0) {
      alert(`订单创建成功！\n订单号: ${res.data.order_no}\n金额: ¥${(res.data.amount / 100).toFixed(2)}\n\n(演示环境，无需实际支付)`)
      // 模拟支付成功
      window.location.href = '/orders'
    } else {
      alert(res.message || '创建订单失败')
    }
  } catch (e: any) {
    alert(e.response?.data?.message || '网络错误')
  } finally {
    paying.value = false
  }
}

function formatDate(dateStr: string) {
  if (!dateStr) return '--'
  return new Date(dateStr).toLocaleDateString('zh-CN')
}
</script>

<style scoped>
.vip-page {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.page-header {
  margin-bottom: 24px;
}

.back-link {
  color: #64748b;
  text-decoration: none;
  font-size: 14px;
}

.back-link:hover { color: #f1f5f9; }

.page-header h1 {
  color: #f1f5f9;
  margin: 8px 0 0;
}

.vip-status {
  background: #1e293b;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 24px;
  border: 1px solid #334155;
}

.vip-active { display: flex; align-items: center; gap: 12px; }
.vip-level {
  padding: 6px 14px;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #fff;
  border-radius: 8px;
  font-weight: 700;
  font-size: 16px;
}
.vip-expire { color: #94a3b8; font-size: 14px; }
.vip-free span { color: #94a3b8; font-size: 16px; }
.vip-desc { color: #64748b; font-size: 13px; margin-top: 4px; }

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 16px;
}

.product-card {
  background: #1e293b;
  border: 2px solid #334155;
  border-radius: 16px;
  padding: 24px;
  position: relative;
  transition: all 0.2s;
}

.product-card:hover { border-color: #64748b; transform: translateY(-2px); }
.product-card.recommended { border-color: #f59e0b; }

.recommend-tag {
  position: absolute;
  top: -10px;
  right: 16px;
  background: #f59e0b;
  color: #000;
  padding: 2px 12px;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 700;
}

.product-name { color: #f1f5f9; font-size: 16px; margin: 0 0 12px; }

.product-price { margin-bottom: 8px; }
.price-symbol { color: #f59e0b; font-size: 18px; }
.price-amount { color: #f59e0b; font-size: 40px; font-weight: 700; }

.product-desc { color: #64748b; font-size: 13px; margin-bottom: 16px; }

.product-features {
  margin-bottom: 16px;
}
.product-features div {
  color: #94a3b8;
  font-size: 13px;
  padding: 3px 0;
}

.pay-channels { display: flex; gap: 8px; }

.pay-btn {
  flex: 1;
  padding: 10px;
  border: 1px solid #475569;
  border-radius: 8px;
  cursor: pointer;
  font-size: 13px;
  font-weight: 600;
  transition: all 0.2s;
}

.pay-btn.alipay { background: #1677ff; color: white; border-color: #1677ff; }
.pay-btn.wechat { background: #07c160; color: white; border-color: #07c160; }
.pay-btn:hover { opacity: 0.9; transform: scale(1.02); }
.pay-btn:disabled { opacity: 0.5; cursor: not-allowed; }

.loading { text-align: center; color: #64748b; padding: 40px; }

.orders-link {
  text-align: center;
  margin-top: 32px;
}
.orders-link a { color: #3b82f6; text-decoration: none; font-size: 14px; }
.orders-link a:hover { text-decoration: underline; }
</style>
