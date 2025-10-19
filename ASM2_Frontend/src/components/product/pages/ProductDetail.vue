<script setup>
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'

import ExtraProducts from '@/components/product/sections/ExtraProducts.vue'
import ProductDisplay from '@/components/product/sections/ProductDisplay.vue'
import AllProducts from '@/components/product/sections/AllProducts.vue'

const route = useRoute()
const productId = ref(route.params.id || '-1')

const product = ref([])
const loading = ref(true)
const error = ref(false)

async function fetchCategories() {
  loading.value = true
  error.value = null
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/products/' + productId.value)
    product.value = response.data
  } catch (err) {
    error.value = true
  } finally {
    loading.value = false
  }
}

watch(
  () => route.params.id,
  (newId) => {
    productId.value = newId || '-1'
    fetchCategories()
  },
  { immediate: true },
)
</script>

<template>
  <div class="container-xl p-2">
    <div v-if="loading" class="text-center mt-5 d-flex flex-column">
      <i class="bi bi-search h1 text-muted"></i>
      <span class="text-muted h4">Finding product with id: {{ productId }}</span>
    </div>
    <div v-else-if="error" class="text-center mt-5 d-flex flex-column">
      <i class="bi bi-search h1 text-muted"></i>
      <span class="text-muted h4">Product not found with id: {{ productId }}</span>
    </div>
    <div v-else="">
      <product-display :product="product" />
      <div class="mt-5"></div>
      <div class="container-fluid p-0">
        <extra-products :categoryId="product.categoryId" />
        <all-products />
      </div>
    </div>
  </div>
</template>
