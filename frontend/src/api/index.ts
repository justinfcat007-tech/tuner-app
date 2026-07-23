import axios from 'axios'

const api = axios.create({
  // Web 与 APK 都通过构建时变量指向正式 API；本地开发继续使用 Vite 的 /api 代理。
  baseURL: import.meta.env.VITE_API_BASE_URL || '/api',
  timeout: 10000,
})

// 请求拦截器：自动添加 token
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 响应拦截器：处理 401
api.interceptors.response.use(
  (res) => res.data,
  (err) => {
    if (err.response?.status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      window.location.href = '/login'
    }
    return Promise.reject(err)
  }
)

export interface APIResponse<T = any> {
  code: number
  message: string
  data: T
}

export interface LoginData {
  username: string
  password: string
}

export interface RegisterData {
  username: string
  email?: string
  password: string
}

export interface UserInfo {
  id: number
  username: string
  email: string
  nickname: string
  avatar: string
  vip_level: number
  vip_expire: string
}

export interface Product {
  id: string
  name: string
  amount: number
  vip_level: number
  vip_days: number
}

export interface Order {
  id: number
  order_no: string
  product_id: string
  product_name: string
  amount: number
  pay_channel: string
  pay_status: number
  paid_at: string
  created_at: string
}

// 认证 API
export const authAPI = {
  login: (data: LoginData) => api.post<any, APIResponse<{token: string; user: UserInfo}>>('/login', data),
  register: (data: RegisterData) => api.post<any, APIResponse<{token: string; user: UserInfo}>>('/register', data),
  profile: () => api.get<any, APIResponse<UserInfo>>('/profile'),
}

// 支付 API
export const payAPI = {
  products: () => api.get<any, APIResponse<Product[]>>('/products'),
  createOrder: (product_id: string, pay_channel: string) =>
    api.post<any, APIResponse<{order_no: string; amount: number; pay_url: string}>>('/order/create', { product_id, pay_channel }),
  orders: () => api.get<any, APIResponse<Order[]>>('/orders'),
}

export default api
