<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'

const isLoading = ref(false)
const email = ref('')
const message = ref('')
const router = useRouter()

const fieldErrors = ref({})

async function onSubmit() {
  isLoading.value = true
  message.value = ''
  fieldErrors.value = {}

  try {
    const res = await axios.post(
      import.meta.env.VITE_API_BASE + '/auth/forgot-password',
      {
        email: email.value,
      },
      { withCredentials: true },
    )
    message.value = res.data
    setTimeout(
      () =>
        router.push({
          path: '/auth/verify-otp',
          query: { email: email.value },
        }),
      1500,
    )
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
      <h2 class="text-center">Forgot password</h2>
      <hr />

      <form @submit.prevent="onSubmit" novalidate>
        <div class="mb-3">
          <label for="email" class="form-label">Email</label>
          <input
            type="email"
            id="email"
            v-model="email"
            class="form-control"
            required
            autocomplete="email"
            :disabled="isLoading"
            :class="{ 'is-invalid': fieldErrors.email }"
            placeholder="Enter registered email"
          />
          <div v-if="fieldErrors.email" class="form-text text-danger">
            {{ fieldErrors.email }}
          </div>
        </div>

        <div v-if="fieldErrors.error" class="form-text text-danger mb-3">
          {{ fieldErrors.error }}
        </div>

        <button type="submit" class="btn w-100 btn-primary text-white" :disabled="isLoading">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Sending...' : 'Send email' }}
        </button>
      </form>

      <div v-if="message" class="alert alert-success mt-3">{{ message }}</div>

      <hr />
      <div class="text-center">
        <span class="text-muted">Remember password?</span>
        <router-link to="/auth/login" class="text-decoration-none ms-1"> Login now </router-link>
      </div>
    </div>
  </div>
</template>
