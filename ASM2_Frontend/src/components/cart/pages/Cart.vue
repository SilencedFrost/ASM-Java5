<script setup>
import CartDisplay from '@/components/cart/sections/CartDisplay.vue'
</script>

<template>
  <div class="flex-fill d-flex">
    <div v-if="isLoading" class="alert alert-info">Loading products ...</div>
    <div v-else-if="fieldErrors" class="alert alert-danger">
      {{ fieldErrors.error }}
    </div>
    <div v-else class="flex-fill d-flex">
      <cart-display />
    </div>
  </div>
</template>
