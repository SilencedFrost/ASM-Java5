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
  router.push(`/seller/products/edit/${props.product.productId}`)
}

function formatPrice(price) {
  return price?.toLocaleString('vi-VN') || '0'
}

function viewProduct() {
  router.push(`/product/${props.product.productId}`).then(() => {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  })
}
</script>
<template>
  <div class="mb-2">
    <div class="card bg-light p-2">
      <div class="d-flex">
        <div class="ratio ratio-1x1" :style="{ width: `150px` }">
          <img
            :src="imageBase + '/product/' + product.thumbnail"
            :alt="product.productName"
            :class="['rounded-2 object-fit-cover', { 'opacity-50': !product.isActive }]"
            @click="viewProduct()"
          />
        </div>
        <div class="d-flex flex-fill wh-100 p-2">
          <div class="d-flex flex-column flex-fill">
            <span class="card-title fw-bold h5">{{ product.productName }}</span>
            <span class="h5 text-danger fw-bold">{{ formatPrice(product.price) }}đ</span>
            <span class="small text-muted text-nowrap">{{ product.totalSales }} lượt mua</span>
            <div class="d-flex align-items-center mt-1">
              <span class="text-muted small me-1">{{ product.rating }} </span>
              <div class="text-warning">
                <i class="bi bi-star" v-if="product.rating < 1"></i
                ><i v-else-if="product.rating < 3" class="bi bi-star-half"></i
                ><i v-else class="bi bi-star-fill"></i>
              </div>
            </div>
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
