<script setup>
import { useRouter } from 'vue-router'
import { defineProps } from 'vue'

const props = defineProps({
  product: {
    type: Object,
    required: true,
  },
})

const imageBase = import.meta.env.VITE_IMAGE_BASE

function addToCart() {
  emits('add-to-cart', props.product)
}

const router = useRouter()

function viewProduct() {
  router.push(`/product/${props.product.productId}`).then(() => {
    window.scrollTo({ top: 0, behavior: 'smooth' }) // scroll to top
  })
}

function formatPrice(price) {
  return price?.toLocaleString('vi-VN') || '0'
}
</script>
<template>
  <div class="card h-100 shadow-sm">
    <div class="position-relative" @click="viewProduct()" style="cursor: pointer">
      <img
        :src="imageBase + '/' + product.imageUrl"
        :alt="product.productName"
        class="card-img-top p-2"
      />
      <hr class="m-0" />
    </div>
    <div class="card-body p-3">
      <div
        class="bg-primary text-white rounded-pill d-inline-flex align-items-center px-2 mb-2"
        style="height: 22px; font-size: 0.85rem"
      >
        <i class="bi bi-chat-left me-1"></i>
        {{ product.commentCount }}
      </div>
      <h6 class="card-title fw-bold">{{ product.productName }}</h6>
      <div class="mb-3">
        <span class="h5 text-danger fw-bold">{{ formatPrice(product.price) }}$</span>
      </div>
      <div class="mt-auto">
        <button class="btn btn-success w-100" @click="addToCart()">
          <i class="bi bi-cart-plus me-1"></i>
          Thêm vào giỏ hàng
        </button>
      </div>
    </div>
  </div>
</template>
