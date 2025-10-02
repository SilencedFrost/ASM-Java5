<script setup>
import Sidebar from '@/components/layouts/Sidebar.vue'
import Carousel from '@/components/sections/Carousel.vue'
import ProductByCat from '@/components/sections/ProductByCat.vue'
</script>

<template>
  <div class="row g-0">
    <div class="col-md-3 col-lg-2 d-none d-md-block p-0 border-end">
      <sidebar />
    </div>
    <div class="col-md-9 col-lg-10 col-12 container-fluid p-2">
      <carousel />
      <product-by-cat />
    </div>
  </div>
</template>
