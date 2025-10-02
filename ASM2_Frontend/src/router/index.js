import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/authStore'

import Home from '@/components/pages/Home.vue'
import Profile from '@/components/pages/Profile.vue'
import Cart from '@/components/pages/Cart.vue'
import ProductDetail from '@/components/pages/ProductDetail.vue'
import Login from '@/components/pages/Login.vue'
import Search from '@/components/pages/Search.vue'
import Signup from '@/components/pages/Signup.vue'

const routes = [
  { path: '/', component: Home, alias: '/home', meta: { title: 'Homepage' } },
  { path: '/profile', component: Profile, meta: { title: 'User profile', requiresAuth: true } },
  { path: '/cart', component: Cart, meta: { title: 'Cart', requiresAuth: true } },
  { path: '/product/:id', component: ProductDetail, meta: { title: 'Product detail' } },
  { path: '/login', component: Login, meta: { title: 'Login' } },
  { path: '/search/:keyword', component: Search, meta: { title: 'Search' } },
  { path: '/register', component: Signup, meta: { title: 'Signup' } },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

// Navigation guard for authentication
router.beforeEach((to, from, next) => {
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
})

router.afterEach((to) => {
  if (to.meta.title) {
    document.title = to.meta.title
  }
})

export default router
