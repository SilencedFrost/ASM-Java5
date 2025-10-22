<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const newPassword = ref('')
const confirmPassword = ref('')
const isLoading = ref(false)
const message = ref('')

const fieldErrors = ref({})

const email = ref(route.query.email || 'Email không xác định')

async function onSubmit() {
  if (newPassword.value !== confirmPassword.value) {
    fieldErrors.value.confirmPassword = 'Passwords do not match.'
    return
  }

  isLoading.value = true
  message.value = ''
  fieldErrors.value = {}

  try {
    const res = await axios.post(
      import.meta.env.VITE_API_BASE + '/auth/reset-password',
      { newPassword: newPassword.value },
      { withCredentials: true },
    )
    message.value = res.data
    setTimeout(() => router.push('/auth/login'), 2000)
  } catch (err) {
    if (err.response && err.response.data) {
      fieldErrors.value = err.response.data
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="d-flex flex-fill justify-content-center align-items-center">
    <div class="card shadow-sm p-3 bg-light" style="max-width: 400px; width: 100%">
      <h2 class="text-center">Reset Password</h2>
      <hr />

      <form @submit.prevent="onSubmit" novalidate>
        <div class="mb-3">
          <label for="newPassword" class="form-label">New Password</label>
          <input
            type="password"
            id="newPassword"
            v-model="newPassword"
            class="form-control"
            required
            :disabled="isLoading"
            :class="{ 'is-invalid': fieldErrors.newPassword }"
          />
          <div v-if="fieldErrors.newPassword" class="form-text text-danger">
            {{ fieldErrors.newPassword }}
          </div>
        </div>

        <div class="mb-3">
          <label for="confirmPassword" class="form-label">Confirm Password</label>
          <input
            type="password"
            id="confirmPassword"
            v-model="confirmPassword"
            class="form-control"
            required
            :disabled="isLoading"
            :class="{ 'is-invalid': fieldErrors.confirmPassword }"
          />
          <div v-if="fieldErrors.confirmPassword" class="form-text text-danger">
            {{ fieldErrors.confirmPassword }}
          </div>
        </div>

        <p class="text-center text-muted small">
          Resetting password for: <strong>{{ email }}</strong>
        </p>

        <div v-if="fieldErrors.error" class="form-text text-danger mb-3">
          {{ fieldErrors.error }}
        </div>

        <button type="submit" class="btn w-100 btn-primary text-white" :disabled="isLoading">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Resetting...' : 'Reset Password' }}
        </button>
      </form>

      <div v-if="message" class="alert alert-success mt-3">{{ message }}</div>

      <hr />
      <div class="text-center">
        <router-link to="/auth/login" class="text-decoration-none ms-1">
          Back to Login
        </router-link>
      </div>
    </div>
  </div>
</template>
