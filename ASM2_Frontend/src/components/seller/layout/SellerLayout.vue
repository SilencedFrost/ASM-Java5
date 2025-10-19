<script setup>
import SellerSidebar from '@/components/seller/sections/SellerSidebar.vue'
</script>

<template>
  <div class="d-flex flex-fill">
    <div style="width: 220px">
      <div class="d-flex h-100">
        <seller-sidebar />
      </div>
    </div>
    <div>
      <div class="d-flex h-100">
        <router-view />
      </div>
    </div>
  </div>
</template>
