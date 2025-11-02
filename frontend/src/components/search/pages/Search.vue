<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

import DisplayItem from '@/components/product/sections/DisplayItem.vue'

const route = useRoute()
const router = useRouter()
const keyword = ref(route.params.keyword || '')
const sortBy = ref(route.query.sortBy || 'creationDate')
const isOrder = ref(route.query.isOrder === 'true')

const products = ref([])
const loading = ref(true)
const error = ref(null)

async function fetchCategories() {
  loading.value = true
  error.value = null
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/products/search', {
      params: {
        keyword: keyword.value,
        sortBy: sortBy.value,
        isOrder: isOrder.value,
      },
    })
    products.value = response.data
  } catch (err) {
    error.value = 'Failed to load data'
  } finally {
    loading.value = false
  }
}

function updateUrlQuery() {
  router.push({
    query: {
      sortBy: sortBy.value,
      isOrder: isOrder.value,
    },
  })
}

watch(sortBy, updateUrlQuery)
watch(isOrder, updateUrlQuery)

watch(
  () => route.fullPath,
  (newPath, oldPath) => {
    if (newPath === oldPath) return

    keyword.value = route.params.keyword || ''
    sortBy.value = route.query.sortBy || 'creationDate'
    isOrder.value = route.query.isOrder === 'true'

    fetchCategories()
  },
)

onMounted(fetchCategories)
</script>

<template>
  <div class="container-lg p-2">
    <div v-if="loading" class="text-center mt-5 d-flex flex-column">
      <i class="bi bi-search h1 text-muted"></i>
      <span class="text-muted h4">Searching products with keyword: {{ keyword }}</span>
    </div>
    <div v-else-if="products.length === 0 || error" class="text-center mt-5 d-flex flex-column">
      <i class="bi bi-search h1 text-muted"></i>
      <span class="text-muted h4">Products not found for keyword: {{ keyword }}</span>
    </div>
    <div v-else>
      <h2>Result for keyword: {{ keyword }}</h2>
      <div class="d-flex justify-content-start align-items-center mb-3">
        <strong class="me-2">Sort by:</strong>

        <select class="form-select w-auto" v-model="sortBy">
          <option value="creationDate">Date</option>
          <option value="price">Price</option>
        </select>

        <button class="btn btn-outline-secondary ms-2" @click="isOrder = !isOrder">
          <i v-if="isOrder" class="bi bi-sort-up"></i>
          <i v-else class="bi bi-sort-down"></i>
        </button>
      </div>

      <div class="row g-3">
        <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12" v-for="product in products">
          <display-item :product="product" />
        </div>
      </div>
    </div>
  </div>
</template>
