<script setup>
import Navbar from '@/components/layouts/Navbar.vue'
import Foot from '@/components/layouts/Footer.vue'
</script>

<template>
  <div class="d-flex flex-column min-vh-100">
    <header class="sticky-top">
      <Navbar />
    </header>

    <div class="d-flex flex-fill">
      <main class="flex-fill">
        <router-view />
      </main>
    </div>

    <footer>
      <Foot />
    </footer>
  </div>
</template>
