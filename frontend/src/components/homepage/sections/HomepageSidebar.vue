<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const categories = ref([])
const loading = ref(true)
const error = ref(null)

async function fetchCategories() {
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/categories', {
      params: { notEmpty: true },
    })
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
  <div class="flex-fill bg-secondary p-3">
    <div class="d-flex flex-column">
      <a href="#newProducts" class="d-flex px-3 py-3 text-decoration-none text-white fw-bold h5"
        >New products</a
      >
      <a href="#bestSeller" class="d-flex px-3 py-3 text-decoration-none text-white fw-bold h5"
        >Best sellers</a
      >
      <div v-for="category in categories">
        <a
          :href="'#category' + category.categoryId"
          class="d-flex px-3 py-3 text-decoration-none text-white fw-bold h5"
          >{{ category.categoryName }}</a
        >
      </div>
    </div>
  </div>
</template>
