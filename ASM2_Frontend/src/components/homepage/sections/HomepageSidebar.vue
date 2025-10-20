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
  <aside class="flex-fill bg-secondary">
    <ul class="list-unstyled mb-0">
      <li v-for="category in categories">
        <a :href="'#category' + category.categoryId" class="d-flex px-3 py-3">
          <div class="align-items-center text-white fw-bold">
            {{ category.categoryName }}
          </div>
        </a>
      </li>
    </ul>
  </aside>
</template>