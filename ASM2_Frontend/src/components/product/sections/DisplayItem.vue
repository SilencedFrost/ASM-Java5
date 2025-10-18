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
  <div class="card h-100 bg-light">
    <div class="position-relative" @click="viewProduct()" style="cursor: pointer">
      <div class="ratio ratio-1x1">
        <img
          :src="imageBase + '/product/' + product.thumbnail"
          :alt="product.productName"
          class="card-img-top p-2 rounded-4 object-fit-cover"
        />
      </div>
      <hr class="m-0" />
    </div>
    <div class="card-body p-3">
      <div class="d-flex w-100">
        <div class="d-flex flex-column">
          <h6 class="card-title fw-bold h3">{{ product.productName }}</h6>
          <span class="h5 text-danger fw-bold">{{ formatPrice(product.price) }}đ</span>
          <span class="small text-muted">{{ product.sellerName }}</span>
        </div>
        <div class="d-flex flex-column flex-fill">
          <span class="ms-auto small text-muted">{{ product.totalSales }} lượt mua</span>
          <button class="btn btn-primary text-white ms-auto mt-auto" @click="addToCart()">
            <i class="bi bi-cart-plus"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
