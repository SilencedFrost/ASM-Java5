<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useCartStore } from '@/stores/cartStore'

import CartDisplayItem from '@/components/cart/sections/CartDisplayItem.vue'

const cartStore = useCartStore()

const isLoading = ref()
const fieldErrors = ref()
const cart = ref([])

async function fetchCart() {
  isLoading.value = true
  try {
    const response = await axios.get(`${import.meta.env.VITE_API_BASE}/cart`, {
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
    cartStore.checkCount()
    cart.value = cart.value.filter((item) => item.variationId !== variationId)
  } finally {
    isLoading.value = false
  }
}

async function updateAmount(quantity, variationId) {
  isLoading.value = true
  try {
    const response = await axios.put(
      `${import.meta.env.VITE_API_BASE}/cart`,
      {
        variationId: variationId,
        quantity: quantity,
      },
      { withCredentials: true },
    )
  } catch (err) {
    fetchCart()
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
      <cart-display-item
        :cartItem="cartItem"
        @remove-product="removeProduct"
        @update-amount="updateAmount"
      />
    </div>
  </div>
</template>
