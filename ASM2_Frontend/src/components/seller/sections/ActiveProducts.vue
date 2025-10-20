<script setup>
import { defineProps } from 'vue'

import SellerDisplayItem from '@/components/seller/sections/SellerDisplayItem.vue'

const props = defineProps({
  products: {
    type: Array,
    required: true,
  },
})
</script>

<template>
  <div class="p-3">
    <h2 class="fw-bold">Active products</h2>
    <div class="d-flex flex-column">
      <div v-for="product in props.products">
        <seller-display-item :product="product" v-if="product.isActive" />
      </div>
    </div>
  </div>
</template>
