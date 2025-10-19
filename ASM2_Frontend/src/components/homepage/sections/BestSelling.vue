<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

import DisplayItem from '@/components/product/sections/DisplayItem.vue'

// Reactive state
const products = ref([])
const loading = ref(true)
const error = ref(null)

// Fetch
async function fetchProducts() {
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/products/top/selling')
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
  <div class="container-fluid">
    <div v-if="loading" class="alert alert-info">Loading top selling products</div>
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>
    <div v-else>
        <div class="row g-3">
          <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12" v-for="product in products">
            <display-item :product="product" />
          </div>
        </div>
        <hr />
    </div>
  </div>
</template>

<style scoped>
section {
  scroll-margin-top: 80px;
}
</style>
