<script setup>
import { onMounted } from 'vue'
import { useAuthStore } from '@/stores/authStore.js'

const authStore = useAuthStore()

onMounted(() => {
  authStore.checkSession()
})
</script>

<template>
  <main class="min-vh-100 d-flex flex-column bg-light">
    <router-view />
  </main>
</template>
