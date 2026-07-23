import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  // 免费调音页面 - 不需要登录
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/TunerView.vue'),
  },
  {
    path: '/guitar',
    name: 'GuitarTuner',
    component: () => import('../views/GuitarTuner.vue'),
  },
  {
    path: '/ukulele',
    name: 'UkuleleTuner',
    component: () => import('../views/UkuleleTuner.vue'),
  },
  {
    path: '/yangqin',
    name: 'YangqinTuner',
    component: () => import('../views/YangqinTuner.vue'),
  },
  {
    path: '/tuning-library',
    name: 'TuningLibrary',
    component: () => import('../views/TuningLibraryView.vue'),
  },

  // 登录页
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/LoginView.vue'),
  },

  // 需要登录的页面
  {
    path: '/pro',
    name: 'Pro',
    component: () => import('../views/ProView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/vip',
    redirect: '/pro',
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('../views/ProfileView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/orders',
    name: 'Orders',
    component: () => import('../views/OrdersView.vue'),
    meta: { requiresAuth: true },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

// 路由守卫 - 只保护需要登录的页面
router.beforeEach((to, _from, next) => {
  if (to.meta.requiresAuth) {
    const token = localStorage.getItem('token')
    if (!token) {
      next('/login')
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
