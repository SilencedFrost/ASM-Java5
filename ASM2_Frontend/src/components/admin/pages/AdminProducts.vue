<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

import AdminActiveProducts from '@/components/admin/sections/AdminActiveProducts.vue'
import AdminInactiveProducts from '@/components/admin/sections/AdminInactiveProducts.vue'

const products = ref([])
const loading = ref(true)
const error = ref(null)

async function fetchProducts() {
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/products', {
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
    <Admin-active-products :products="products" />
    <Admin-inactive-products :products="products" />
  </div>
</template>
