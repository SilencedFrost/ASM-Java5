<script setup>
import HomepageSidebar from '@/components/homepage/sections/HomepageSidebar.vue'
</script>

<template>
  <div class="d-flex flex-fill">
    <div style="min-width: 250px" class="d-none d-md-block">
      <div class="d-flex h-100">
        <homepage-sidebar />
      </div>
    </div>
    <div class="flex-fill">
      <div class="d-flex">
        <router-view />
      </div>
    </div>
  </div>
</template>
