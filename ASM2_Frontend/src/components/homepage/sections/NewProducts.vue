<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

import DisplayItem from '@/components/product/sections/DisplayItem.vue'

const products = ref([])
const loading = ref(true)
const error = ref(null)

async function fetchProducts() {
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/products/top/new')
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
  <section id="newProducts">
    <div class="text-center my-4">
      <h1 class="fw-bold">New products</h1>
    </div>
    <div v-if="loading" class="alert alert-info">Loading products...</div>
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
  </section>
</template>
