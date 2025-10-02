<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

// Reactive state
const categories = ref([])
const loading = ref(true)
const error = ref(null)

// Fetch
async function fetchCategories() {
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/categories')
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
  <!-- Sidebar -->
  <div class="bg-white w-100 p-0">
    <!-- Product Categories -->
    <ul class="list-unstyled mb-0">
      <!-- Điện thoại -->
      <li v-for="category in categories">
        <a
          :href="'#category' + category.categoryId"
          class="d-flex align-items-center justify-content-between px-3 py-3 text-decoration-none text-black"
        >
          <div class="d-flex align-items-center">{{ category.categoryName }}</div>
        </a>
      </li>
    </ul>
  </div>
</template>
