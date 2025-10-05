<script setup>
import ProfileSidebar from '@/components/profile/sections/ProfileSidebar.vue'
</script>

<template>
  <div class="row g-0 flex-fill">
    <div class="col-md-3 col-lg-2 d-none d-md-block p-0 m-0">
      <div class="d-flex h-100">
        <profile-sidebar />
      </div>
    </div>
    <div class="col-md-9 col-lg-10 col-12">
      <div class="d-flex h-100">
        <router-view />
      </div>
    </div>
  </div>
</template>
