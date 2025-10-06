<script setup></script>
<template>
  <div class="d-flex flex-fill">
    <div class="fixed-top">
      <router-link class="text-white ms-2 fs-1" to="/"
        ><i class="bi bi-house-fill"></i
      ></router-link>
    </div>
    <router-view />
  </div>
</template>
