<script setup>
import { ref } from 'vue'

const isLoading = ref(false)

function onRegister() {}

function registerWithGoogle() {}
</script>

<template>
  <div class="d-flex flex-fill justify-content-center align-items-center py-4 bg-warning">
    <div class="card shadow-sm p-4 bg-light" style="max-width: 500px; width: 100%">
      <h2 class="text-center text-dark">Đăng ký</h2>
      <hr />
      <form @submit.prevent="onRegister">
        <div class="mb-3">
          <label for="username" class="form-label text-dark"
            >Tên người dùng <span class="text-danger">*</span></label
          >
          <input type="text" id="username" class="form-control" required :disabled="isLoading" />
        </div>

        <div class="mb-3">
          <label for="email" class="form-label text-dark"
            >Email <span class="text-danger">*</span></label
          >
          <input type="email" id="email" class="form-control" required :disabled="isLoading" />
        </div>

        <div class="mb-3">
          <label for="phone" class="form-label text-dark"
            >Số điện thoại <span class="text-danger">*</span></label
          >
          <input type="tel" id="phone" class="form-control" required :disabled="isLoading" />
        </div>

        <div class="row">
          <div class="col-md-6 mb-3">
            <label for="password" class="form-label text-dark"
              >Mật khẩu <span class="text-danger">*</span></label
            >
            <div class="input-group">
              <input id="password" class="form-control" required :disabled="isLoading" />
            </div>
          </div>

          <div class="col-md-6 mb-3">
            <label for="confirmPassword" class="form-label"
              >Xác nhận mật khẩu <span class="text-danger">*</span></label
            >
            <input
              type="password"
              id="confirmPassword"
              class="form-control"
              required
              :disabled="isLoading"
            />
          </div>
        </div>

        <button type="submit" class="btn btn-dark w-100" :disabled="isLoading">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Đang đăng ký...' : 'Đăng ký' }}
        </button>
      </form>

      <button
        class="btn btn-primary text-white w-100 mt-3"
        @click="registerWithGoogle"
        :disabled="isLoading"
      >
        <i class="fab fa-google me-2"></i>
        Đăng ký bằng Google
      </button>

      <hr />

      <div class="text-center">
        <span class="text-muted">Đã có tài khoản? </span>
        <router-link to="/login" class="text-decoration-none">Đăng nhập ngay</router-link>
      </div>
    </div>
  </div>
</template>
