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

  if (!email.value) {
    fieldErrors.value = { email: 'Email không được để trống.' }
    isLoading.value = false
    return
  }

  try {
    const res = await axios.post(
      import.meta.env.VITE_API_BASE + '/auth/forgot-password',
      {
        email: email.value
      },
      { withCredentials: true },
    )

    message.value = res.data

    setTimeout(() => router.push({
      path: '/auth/verify-otp',
      query: { email: email.value }
    }), 1500)
  } catch (err) {
    if (err.response && err.response.data) {
      fieldErrors.value = { email: err.response.data }
    } else {
      fieldErrors.value = { error: 'Cannot connect to server' }
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="d-flex flex-fill justify-content-center align-items-center bg-warning min-vh-100">
    <div class="card shadow-sm p-3 bg-light" style="max-width: 400px; width: 100%">
      <h2 class="text-center text-dark">Quên mật khẩu</h2>
      <hr />

      <form @submit.prevent="onSubmit" novalidate>
        <div class="mb-3">
          <label for="email" class="form-label text-dark">Email</label>
          <input type="email" id="email" v-model="email" class="form-control" required autocomplete="email"
            :disabled="isLoading" :class="{ 'is-invalid': fieldErrors.email }" />

          <div class="form-text text-dark mt-1">
            Nhập email đã đăng ký để nhận mã.
          </div>
          
          <div v-if="fieldErrors.email" class="form-text text-danger">
            {{ fieldErrors.email }}
          </div>
        </div>

        <div v-if="fieldErrors.error" class="form-text text-danger mb-3">
          {{ fieldErrors.error }}
        </div>

        <button type="submit" class="btn w-100 btn-primary text-white" :disabled="isLoading">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Đang gửi...' : 'Gửi email' }}
        </button>
      </form>

      <div v-if="message" class="alert alert-success mt-3">{{ message }}</div>

      <hr />
      <div class="text-center">
        <span class="text-muted">Nhớ mật khẩu?</span>
        <router-link to="/auth/login" class="text-decoration-none ms-1">
          Đăng nhập ngay
        </router-link>
      </div>
    </div>
  </div>
</template>