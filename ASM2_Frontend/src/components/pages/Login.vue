<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/authStore'

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

const username = ref('')
const password = ref('')
const isLoading = ref(false)
const errorMessage = ref('')

function validateUsernameOrEmail() {
  return username.value != null && username.value.trim() !== ''
}

function validatePassword() {
  return password.value != null && password.value.trim() !== ''
}

function redirectAfterLogin() {
  const redirectPath = route.query.redirect || '/'
  router.push(redirectPath)
}

onMounted(async () => {
  await authStore.checkSession()
  if (authStore.userId > 0) {
    redirectAfterLogin()
  }
})

async function onLogin() {
  errorMessage.value = ''

  if (!validateUsernameOrEmail() || !validatePassword()) {
    errorMessage.value = 'Please enter both username/email and password.'
    return
  }

  isLoading.value = true
  try {
    const res = await axios.post(
      import.meta.env.VITE_API_BASE + '/auth/login',
      {
        usernameOrEmail: username.value,
        password: password.value,
      },
      { withCredentials: true },
    )

    if (res.data && res.data.userId) {
      authStore.setUser(res.data)
      redirectAfterLogin()
    } else {
      errorMessage.value = 'Invalid credentials or user not found.'
      authStore.clearUser()
    }
  } catch (err) {
    errorMessage.value = 'Login failed. Please check your credentials.'
    authStore.clearUser()
  } finally {
    isLoading.value = false
  }
}

function loginWithGoogle() {}
</script>

<template>
  <div class="container d-flex justify-content-center align-items-center h-100">
    <div class="card shadow-sm p-3" style="max-width: 400px; width: 100%">
      <h2 class="mb-3 text-center text-primary">Đăng nhập</h2>
      <hr class="p-0 m-2" />
      <form @submit.prevent="onLogin">
        <div class="mb-3">
          <label for="username" class="form-label">Tên đăng nhập hoặc email</label>
          <input
            type="text"
            id="username"
            v-model="username"
            class="form-control"
            required
            autocomplete="username"
            placeholder="Username or email"
            :disabled="isLoading"
          />
        </div>
        <div class="mb-3">
          <label for="password" class="form-label">Mật khẩu</label>
          <input
            type="password"
            id="password"
            v-model="password"
            class="form-control"
            required
            autocomplete="current-password"
            placeholder="Password"
            :disabled="isLoading"
          />
        </div>
        <button type="submit" class="btn btn-primary w-100" :disabled="isLoading">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Đang đăng nhập...' : 'Đăng nhập' }}
        </button>
      </form>
      <button class="btn btn-danger w-100 mt-3" @click="loginWithGoogle" :disabled="isLoading">
        <i class="fab fa-google me-2"></i> Đăng nhập bằng Google
      </button>
      <div class="mt-3 text-center">
        <router-link to="/forgot-password" class="text-decoration-none">Quên mật khẩu?</router-link>
        <span class="mx-2">|</span>
        <router-link to="/register" class="text-decoration-none">Đăng ký tài khoản</router-link>
      </div>
    </div>
  </div>
</template>
