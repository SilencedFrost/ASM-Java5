<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

const props = defineProps({
  product: {
    type: Object,
    required: true,
  },
})

const imageBase = import.meta.env.VITE_IMAGE_BASE

const router = useRouter()

const isLoading = ref(false)
const error = ref(null)

async function toggleState() {
  isLoading.value = true
  try {
    const response = await axios.patch(
      import.meta.env.VITE_API_BASE + '/products/' + props.product.productId + '/toggle-active',
      {},
      { withCredentials: true },
    )
    props.product.isActive = !props.product.isActive
  } catch (err) {
    error.value = 'Failed to toggle'
  } finally {
    isLoading.value = false
  }
}

function editProduct() {
  router.push(`/admin/products/edit/${props.product.productId}`)
}

function formatPrice(price) {
  return price?.toLocaleString('vi-VN') || '0'
}
</script>
<template>
  <div class="mb-2">
    <div class="card bg-light p-2">
      <div class="d-flex">
        <div class="ratio ratio-1x1" :style="{ maxWidth: `20%` }">
          <img
            :src="imageBase + '/product/' + product.thumbnail"
            :alt="product.productName"
            :class="['rounded-2 object-fit-cover', { 'opacity-50': !product.isActive }]"
          />
        </div>
        <div class="d-flex flex-fill wh-100 p-2">
          <div class="d-flex flex-column flex-fill">
            <span class="card-title fw-bold h5">{{ product.productName }}</span>
            <span class="h5 text-danger fw-bold">{{ formatPrice(product.price) }}đ</span>
            <span class="small text-muted text-nowrap">{{ product.totalSales }} lượt mua</span>
          </div>
          <div class="d-flex flex-column flex-shrink-0">
            <button
              class="btn btn-primary text-white ms-auto mt-auto w-100"
              @click="toggleState"
              :disabled="isLoading"
            >
              <span
                v-if="isLoading"
                class="spinner-border spinner-border-sm me-2"
                role="status"
              ></span>
              <span v-if="product.isActive">Deactivate</span>
              <span v-if="!product.isActive">Activate</span>
            </button>
            <button class="btn btn-success text-white mt-2 w-100" @click="editProduct()">
              Edit
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
