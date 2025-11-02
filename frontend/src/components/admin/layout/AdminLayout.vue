<script setup>
import AdminSidebar from '@/components/admin/sections/AdminSidebar.vue'
</script>

<template>
  <div class="d-flex flex-fill">
    <div style="min-width: 220px">
      <div class="d-flex h-100">
        <Admin-Sidebar />
      </div>
    </div>
    <div class="flex-fill">
      <div class="d-flex">
        <router-view />
      </div>
    </div>
  </div>
</template>
