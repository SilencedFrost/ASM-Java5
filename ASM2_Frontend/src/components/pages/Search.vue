<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'

import DisplayItem from '@/components/sections/DisplayItem.vue'

// Lấy ID sản phẩm từ URL
const route = useRoute()
const keyword = ref(route.params.keyword)

// Reactive state
const products = ref([])
const loading = ref(true)
const error = ref(null)

// Fetch
async function fetchCategories() {
  loading.value = true
  error.value = null
  try {
    const response = await axios.get(
      import.meta.env.VITE_API_BASE + '/products/search/' + keyword.value,
    )
    products.value = response.data
  } catch (err) {
    error.value = 'Failed to load data'
  } finally {
    loading.value = false
  }
}

onMounted(fetchCategories)

watch(
  () => route.params.keyword,
  (newKeyword) => {
    keyword.value = newKeyword
    fetchCategories()
  },
)
</script>

<template>
  <div class="container-fluid p-2">
    <div v-if="loading" class="alert alert-info">Loading categories...</div>
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>
    <div v-else>
      <h2>Kết quả tìm kiếm cho từ khóa: {{ keyword }}</h2>
      <div class="row g-3">
        <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12" v-for="product in products">
          <display-item :product="product" />
        </div>
      </div>
    </div>
  </div>
</template>
