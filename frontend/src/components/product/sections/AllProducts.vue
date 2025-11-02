<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

import DisplayItem from '@/components/product/sections/DisplayItem.vue'

const products = ref([])
const loading = ref(true)
const error = ref(null)

async function fetchCategory() {
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/products')
    products.value = response.data
  } catch (err) {
    error.value = 'Failed to load data'
  } finally {
    loading.value = false
  }
}

onMounted(fetchCategory)
</script>
<template>
  <div class="container-fluid">
    <div v-if="loading" class="alert alert-info">Loading all products...</div>
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>
    <div v-else>
      <h1 class="text-center my-3">All products</h1>
      <hr />
      <div class="row g-3 p-0">
        <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12" v-for="product in products">
          <display-item :product="product" />
        </div>
      </div>
      <div v-if="!products" class="alert alert-warning mt-2">No similar products found found.</div>
    </div>
  </div>
</template>

<style scoped>
section {
  scroll-margin-top: 80px;
}
</style>
