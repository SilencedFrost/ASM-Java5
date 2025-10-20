<script setup>
import axios from 'axios'
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/authStore'

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

const email = ref('')
const password = ref('')
const rememberMe = ref(false)

const isLoading = ref(false)
const fieldErrors = ref({})

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
  isLoading.value = true
  try {
    const res = await axios.post(
      import.meta.env.VITE_API_BASE + '/auth/login',
      {
        email: email.value,
        password: password.value,
        rememberMe: rememberMe.value,
      },
      { withCredentials: true },
    )

    if (res.data && res.data.userId) {
      authStore.setUser(res.data)
      redirectAfterLogin()
    } else {
      authStore.clearUser()
    }
  } catch (err) {
    authStore.clearUser()
    if (err.response && err.response.data) {
      fieldErrors.value = err.response.data
    }
  } finally {
    isLoading.value = false
  }
}

function loginWithGoogle() {}
</script>

<template>
  <div class="d-flex flex-fill justify-content-center align-items-center">
    <div class="card shadow-sm p-3 bg-light" style="max-width: 400px; width: 100%">
      <h2 class="text-center">Login</h2>
      <hr />
      <form @submit.prevent="onLogin" novalidate>
        <div class="mb-3">
          <div>
            <label for="email" class="form-label">Email</label>
            <input
              type="email"
              id="email"
              v-model="email"
              class="form-control"
              required
              autocomplete="email"
              :disabled="isLoading"
            />
          </div>
          <div v-if="fieldErrors.email" class="form-text text-danger">
            {{ fieldErrors.email }}
          </div>
        </div>
        <div class="mb-3">
          <div>
            <label for="password" class="form-label">Password</label>
            <input
              type="password"
              id="password"
              v-model="password"
              class="form-control"
              required
              autocomplete="current-password"
              :disabled="isLoading"
            />
            <div v-if="fieldErrors.password" class="form-text text-danger">
              {{ fieldErrors.password }}
            </div>
          </div>
        </div>
        <div class="mb-3">
          <div>
            <input
              type="checkbox"
              id="rememberMe"
              v-model="rememberMe"
              class="form-check-input me-2"
              :disabled="isLoading"
            />
            <label for="rememberMe" class="form-check-label">Remember Me</label>
          </div>
        </div>
        <div v-if="fieldErrors.error" class="form-text text-danger mb-3">
          {{ fieldErrors.error }}
        </div>
        <button type="submit" class="btn w-100 btn-dark text-white" :disabled="isLoading">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Logging in...' : 'Login' }}
        </button>
      </form>
      <button
        class="btn w-100 mt-3 bg-primary text-white"
        @click="loginWithGoogle"
        :disabled="isLoading"
      >
        Login with Google
      </button>

      <hr />

      <div class="text-center">
        <router-link to="/auth/forgot-password" class="text-decoration-none text-muted"
          >Forgot password?</router-link
        >
        <span class="mx-2">|</span>
        <router-link to="/auth/register" class="text-decoration-none text-muted"
          >Register</router-link
        >
      </div>
    </div>
  </div>
</template>
