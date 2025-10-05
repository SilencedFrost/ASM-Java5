<script setup>
import { ref } from 'vue'

const isLoading = ref(false)

function onSubmit() {}
</script>

<template>
  <div class="d-flex flex-fill justify-content-center align-items-center bg-warning">
    <div class="card shadow-sm p-3 bg-light" style="max-width: 400px; width: 100%">
      <h2 class="text-center text-dark">Đăng nhập</h2>
      <hr />
      <form @submit.prevent="onSubmit">
        <div class="mb-3">
          <label for="username" class="form-label text-dark">Email</label>
          <input
            type="text"
            id="username"
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
