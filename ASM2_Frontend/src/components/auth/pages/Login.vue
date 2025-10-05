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
  <div class="d-flex flex-fill justify-content-center align-items-center bg-warning">
    <div class="card shadow-sm p-3 bg-light" style="max-width: 400px; width: 100%">
      <h2 class="text-center text-dark">Đăng nhập</h2>
      <hr />
      <form @submit.prevent="onLogin">
        <div class="mb-3">
          <label for="username" class="form-label text-dark">Email</label>
          <input
            type="text"
            id="username"
            v-model="username"
            class="form-control"
            required
            autocomplete="username"
            :disabled="isLoading"
          />
        </div>
        <div class="mb-3">
          <label for="password" class="form-label text-dark">Mật khẩu</label>
          <input
            type="password"
            id="password"
            v-model="password"
            class="form-control"
            required
            autocomplete="current-password"
            :disabled="isLoading"
          />
        </div>
        <button type="submit" class="btn w-100 btn-dark text-white" :disabled="isLoading">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Đang đăng nhập...' : 'Đăng nhập' }}
        </button>
      </form>
      <button
        class="btn w-100 mt-3 bg-primary text-white"
        @click="loginWithGoogle"
        :disabled="isLoading"
      >
        Đăng nhập bằng Google
      </button>

      <hr />

      <div class="text-center">
        <router-link to="/forgot-password" class="text-decoration-none text-muted"
          >Quên mật khẩu?</router-link
        >
        <span class="mx-2">|</span>
        <router-link to="/register" class="text-decoration-none text-muted"
          >Đăng ký tài khoản</router-link
        >
      </div>
    </div>
  </div>
</template>
