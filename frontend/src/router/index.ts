import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/TunerView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/LoginView.vue'),
  },
  {
    path: '/yangqin',
    name: 'YangqinTuner',
    component: () => import('../views/YangqinTuner.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/guitar',
    name: 'GuitarTuner',
    component: () => import('../views/GuitarTuner.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/ukulele',
    name: 'UkuleleTuner',
    component: () => import('../views/UkuleleTuner.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/vip',
    name: 'VIP',
    component: () => import('../views/VIPView.vue'),
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

// 路由守卫
router.beforeEach((to, _from, next) => {
  const token = localStorage.getItem('token')
  if (to.meta.requiresAuth && !token) {
    next('/login')
  } else if (to.path === '/login' && token) {
    next('/')
  } else {
    next()
  }
})

export default router
