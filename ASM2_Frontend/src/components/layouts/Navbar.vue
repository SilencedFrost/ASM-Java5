<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/authStore'
import logoImage from '@/assets/images/logo.png'

const authStore = useAuthStore()

const searchQuery = ref('')
const router = useRouter()

function onSearch() {
  router.push(`/search/${encodeURIComponent(searchQuery.value)}`)
}

function goHome() {
  router.push('/').then(() => {
    window.scrollTo({ top: 0, behavior: 'smooth' }) // scroll to top
  })
}
</script>

<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
    <div class="container-fluid d-flex align-items-center">
      <!-- Logo -->
      <div class="navbar-brand flex-shrink-0">
        <img :src="logoImage" alt="" style="width: 50px" @click="goHome" />
      </div>

      <!-- Burger button -->
      <button
        class="navbar-toggler flex-shrink-0"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#navbarNavDropdown"
        aria-controls="navbarNavDropdown"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-icon"></span>
      </button>

      <!-- Navbar content -->
      <div class="collapse navbar-collapse" id="navbarNavDropdown">
        <ul class="navbar-nav">
          <li class="nav-item">
            <!-- Search -->
            <form class="d-flex w-100" @submit.prevent="onSearch">
              <input
                class="form-control me-2"
                type="search"
                v-model="searchQuery"
                placeholder="Tìm kiếm"
                aria-label="Search"
              />
              <button class="btn btn-outline-secondary" type="submit">
                <i class="bi bi-search"></i>
              </button>
            </form>
          </li>
          <!-- Giỏ hàng -->
          <li class="nav-item">
            <router-link class="nav-link d-flex align-items-center" to="/cart">
              <i class="bi bi-cart me-2" style="font-size: 20px"></i>
              Giỏ hàng
            </router-link>
          </li>
          <!-- Account dropdown/collapse -->
          <li class="nav-item dropdown">
            <!-- Desktop dropdown -->
            <a
              class="nav-link dropdown-toggle d-flex align-items-center d-none d-lg-flex"
              href="#"
              id="userDropdown"
              role="button"
              data-bs-toggle="dropdown"
              aria-expanded="false"
            >
              <i class="bi bi-person-circle me-2" style="font-size: 20px"></i>
              Tài khoản
            </a>
            <ul class="dropdown-menu" aria-labelledby="userDropdown">
              <div v-if="!authStore.isLoggedIn">
                <li>
                  <router-link class="dropdown-item" to="/login">Đăng nhập</router-link>
                </li>
                <li>
                  <router-link class="dropdown-item" to="/register">Đăng ký</router-link>
                </li>
              </div>
              <div v-if="authStore.isLoggedIn">
                <li>
                  <div class="dropdown-item">Welcome, {{ authStore.username }}</div>
                </li>
                <li class="nav-item">
                  <div class="dropdown-item" @click="authStore.logOut">Đăng xuất</div>
                </li>
                <li>
                  <router-link class="dropdown-item" to="">Quản lý tài khoản</router-link>
                </li>
              </div>
            </ul>

            <!-- Mobile collapse -->
            <a
              class="nav-link d-flex align-items-center d-lg-none"
              href="#userOptions"
              data-bs-toggle="collapse"
              aria-expanded="false"
              aria-controls="userOptions"
            >
              <i class="bi bi-person-circle me-2" style="font-size: 20px"></i>
              Tài khoản
            </a>
          </li>
        </ul>

        <div class="collapse d-lg-none" id="userOptions">
          <ul class="navbar-nav">
            <div v-if="!authStore.isLoggedIn">
              <li class="nav-item">
                <router-link class="nav-link ps-4" to="/login">Đăng nhập</router-link>
              </li>
              <li class="nav-item">
                <router-link class="nav-link ps-4" to="/register">Đăng ký thành viên</router-link>
              </li>
            </div>
            <div v-if="authStore.isLoggedIn">
              <li>
                <div class="nav-link ps-4">Welcome, {{ authStore.username }}</div>
              </li>
              <li class="nav-item">
                <div class="nav-link ps-4" @click="authStore.logOut">Đăng xuất</div>
              </li>
              <li class="nav-item">
                <router-link class="nav-link ps-4" to="">Quản lý tài khoản</router-link>
              </li>
            </div>
          </ul>
        </div>
      </div>
    </div>
  </nav>
</template>
