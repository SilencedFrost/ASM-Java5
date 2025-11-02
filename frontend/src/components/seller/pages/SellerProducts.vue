<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

import AuthActiveProducts from '@/components/seller/sections/AuthActiveProducts.vue'
import AuthInactiveProducts from '@/components/seller/sections/AuthInactiveProducts.vue'

const products = ref([])
const loading = ref(true)
const error = ref(null)

async function fetchProducts() {
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/sellers/products', {
      withCredentials: true,
    })
    products.value = response.data
  } catch (err) {
    error.value = 'Failed to load data'
  } finally {
    loading.value = false
  }
}

onMounted(fetchProducts)
</script>

<template>
  <div v-if="loading" class="alert alert-info">Loading products...</div>
  <div v-else-if="error" class="alert alert-danger">
    {{ error }}
  </div>
  <div v-else class="flex-fill">
    <auth-active-products :products="products" />
    <auth-inactive-products :products="products" />
  </div>
</template>
