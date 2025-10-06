<script setup>
import { ref } from 'vue'

const isLoading = ref(false)

function onSubmit() {
}
</script>

<template>
  <div class="d-flex flex-fill justify-content-center align-items-center bg-warning min-vh-100">
    <div class="card shadow-sm p-3 bg-light" style="max-width: 400px; width: 100%;">
      <h2 class="text-center text-dark mb-3">Quên mật khẩu</h2>
      <hr class="mt-0 mb-3" />

      <form @submit.prevent="onSubmit">
        <div class="mb-3">
          <label for="email" class="form-label text-dark">Email</label>
          <input
            type="email"
            id="email"
            class="form-control"
            required
            autocomplete="email"
            :disabled="isLoading"
          />
          <div class="form-text text-dark mt-1">
            Nhập email đã đăng ký để nhận mã.
          </div>
        </div>

        <button type="submit" class="btn w-100 btn-dark text-white" :disabled="isLoading">
          <span
            v-if="isLoading"
            class="spinner-border spinner-border-sm me-2"
            role="status"
          ></span>
          {{ isLoading ? 'Đang gửi...' : 'Gửi email' }}
        </button>
      </form>

      <hr class="my-3" />
      <div class="text-center">
        <span class="text-muted">Nhớ mật khẩu?</span>
        <router-link to="/login" class="text-decoration-none ms-1">
          Đăng nhập ngay
        </router-link>
      </div>
    </div>
  </div>
</template>
