<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

import DisplayItem from '@/components/sections/DisplayItem.vue'

// Reactive state
const categories = ref([])
const loading = ref(true)
const error = ref(null)

// Fetch
async function fetchCategories() {
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/categories/products')
    categories.value = response.data
  } catch (err) {
    error.value = 'Failed to load data'
  } finally {
    loading.value = false
  }
}

onMounted(fetchCategories)
</script>
<template>
  <div class="container-fluid">
    <div v-if="loading" class="alert alert-info">Loading categories...</div>
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>
    <div v-else>
      <section
        v-for="category in categories"
        :key="category.categoryId"
        :id="'category' + category.categoryId"
      >
        <div class="text-center my-4">
          <h1 class="fw-bold">
            {{ category.categoryName }}
          </h1>
        </div>
        <div class="row g-3">
          <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12" v-for="product in category.products">
            <display-item :product="product" />
          </div>
        </div>
        <hr />
      </section>
      <div v-if="categories.length === 0" class="alert alert-warning mt-2">
        No categories found.
      </div>
    </div>
  </div>
</template>

<style scoped>
section {
  scroll-margin-top: 80px;
}
</style>
