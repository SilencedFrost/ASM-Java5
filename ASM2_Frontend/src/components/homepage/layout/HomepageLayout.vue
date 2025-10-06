<script setup>
import HomepageSidebar from '@/components/homepage/sections/HomepageSidebar.vue'
</script>

<template>
  <div class="row g-0 flex-fill">
    <div class="col-md-3 col-lg-2 d-none d-md-block">
      <div class="d-flex h-100">
        <homepage-sidebar />
      </div>
    </div>
    <div class="col-md-9 col-lg-10 col-12">
      <div class="d-flex h-100">
        <router-view />
      </div>
    </div>
  </div>
</template>
