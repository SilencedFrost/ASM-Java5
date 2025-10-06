import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/authStore'

import HomepageLayout from '@/components/homepage/layout/HomepageLayout.vue'
import Homepage from '@/components/homepage/pages/Homepage.vue'
import ProfileLayout from '@/components/profile/layout/ProfileLayout.vue'
import Profile from '@/components/profile/pages/Profile.vue'
import Cart from '@/components/cart/pages/Cart.vue'
import ProductDetail from '@/components/product/pages/ProductDetail.vue'
import Login from '@/components/auth/pages/Login.vue'
import Search from '@/components/search/pages/Search.vue'
import Signup from '@/components/auth/pages/Signup.vue'
import Generic from '@/components/base/layout/Generic.vue'
import Payment from '@/components/profile/pages/Payment.vue'
import Address from '@/components/profile/pages/Address.vue'
import ChangePass from '@/components/profile/pages/ChangePass.vue'
import ForgotPassword from '@/components/auth/pages/ForgotPassword.vue'
import OrderDetail from '@/components/order/pages/OrderDetail.vue'
import OrderStatus from '@/components/order/pages/OrderStatus.vue'

const routes = [
  { path: '/login', component: Login, meta: { title: 'Login' } },
  { path: '/register', component: Signup, meta: { title: 'Register' } },
  { path: '/forgot-password', component: ForgotPassword, meta: { title: 'Forgot password' } },
  { path: '/order', component: OrderDetail, meta: { title: 'Order detail' } },
  {
    path: '/',
    component: Generic,
    children: [
      { path: '/search/:keyword', component: Search, meta: { title: 'Search' } },
      { path: '/product/:id', component: ProductDetail, meta: { title: 'Product detail' } },
      { path: '/cart', component: Cart, meta: { title: 'Cart', requiresAuth: true } },
      { path: '/status', component: OrderStatus, meta: { title: 'Trạng thái đơn hàng' } },
      {
        path: '/',
        component: HomepageLayout,
        alias: '/home',
        meta: { title: 'Homepage' },
        children: [{ path: '', component: Homepage }],
      },
      {
        path: '/profile',
        component: ProfileLayout,
        meta: { title: 'User profile', requiresAuth: true },
        children: [
          { path: '', component: Profile },
          { path: 'payment', component: Payment },
          { path: 'address', component: Address },
          { path: 'change-pass', component: ChangePass },
        ],
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

// Navigation guard for authentication
/* router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()

  if (to.meta.requiresAuth && !authStore.isLoggedIn) {
    // Save the target route so we can redirect later
    next({
      path: '/login',
      query: { redirect: to.fullPath },
    })
  } else {
    next()
  }
}) */

router.afterEach((to) => {
  if (to.meta.title) {
    document.title = to.meta.title
  }
})

export default router
