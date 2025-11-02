<script setup>
import ProductByCat from '@/components/homepage/sections/ProductByCat.vue'
import NewProducts from '@/components/homepage/sections/NewProducts.vue'
import BestSelling from '@/components/homepage/sections/BestSelling.vue'
</script>

<template>
  <div class="flex-fill bg-light p-2">
    <new-products />
    <best-selling />
    <product-by-cat />
  </div>
</template>
