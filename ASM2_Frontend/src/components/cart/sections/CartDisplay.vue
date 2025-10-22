<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

import CartDisplayItem from '@/components/cart/sections/CartDisplayItem.vue'

const isLoading = ref()
const fieldErrors = ref()
const cart = ref([])

async function fetchCart() {
  isLoading.value = true
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/cart', {
      withCredentials: true,
    })
    cart.value = response.data
  } catch (err) {
    if (err.response) {
      if (err.response.status === 401) {
        isLoading.value = false
        router.push('/auth/login')
        return
      }
      if (err.response.data) {
        fieldErrors.value = err.response.data
      }
    } else {
      console.error('Network or unknown error:', err)
    }
  } finally {
    isLoading.value = false
  }
}

async function removeProduct(variationId) {
  isLoading.value = true
  try {
    await axios.delete(`${import.meta.env.VITE_API_BASE}/cart/product/${variationId}`, {
      withCredentials: true,
    })
    cart.value = cart.value.filter((item) => item.variationId !== variationId)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchCart)
</script>
<template>
  <div class="container-lg d-flex flex-column p-2">
    <h2 class="fw-bold">Your cart</h2>
    <div v-for="cartItem in cart">
      <cart-display-item :cartItem="cartItem" @remove-product="removeProduct" />
    </div>
  </div>
</template>
