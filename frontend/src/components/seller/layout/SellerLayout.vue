<script setup>
import SellerSidebar from '@/components/seller/sections/SellerSidebar.vue'
</script>

<template>
  <div class="d-flex flex-fill">
    <div style="min-width: 220px">
      <div class="d-flex h-100">
        <seller-sidebar />
      </div>
    </div>
    <div class="flex-fill">
      <div class="d-flex">
        <router-view />
      </div>
    </div>
  </div>
</template>
