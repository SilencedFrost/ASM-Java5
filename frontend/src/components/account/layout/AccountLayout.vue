<script setup>
import AccountSidebar from '@/components/account/sections/AccountSidebar.vue'
</script>

<template>
  <div class="d-flex flex-fill">
    <div style="width: 220px">
      <div class="d-flex h-100">
        <account-sidebar />
      </div>
    </div>
    <div class="flex-fill">
      <div class="d-flex">
        <router-view />
      </div>
    </div>
  </div>
</template>
