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
    window.scrollTo({ top: 0, behavior: 'smooth' })
  })
}

function formatPrice(price) {
  return price?.toLocaleString('vi-VN') || '0'
}
</script>
<template>
  <div class="card h-100 bg-light">
    <div
      class="position-relative ratio ratio-1x1"
      :style="{ cursor: product.isActive ? 'pointer' : 'default' }"
      @click="product.isActive && viewProduct()"
    >
      <img
        :src="imageBase + '/product/' + product.thumbnail"
        :alt="product.productName"
        :class="[
          'card-img-top p-2 rounded-4 object-fit-cover',
          { 'opacity-50': !product.isActive },
        ]"
      />
    </div>
    <div class="card-body p-3">
      <div class="d-flex flex-fill h-100">
        <div class="d-flex flex-column flex-fill">
          <span class="card-title fw-bold h5">{{ product.productName }}</span>
          <span class="h5 text-danger fw-bold"
            ><span v-if="product.isActive">{{ formatPrice(product.price) }}đ</span>
            <span v-else="!product.isActive">INACTIVE</span></span
          >
          <span class="small text-muted">{{ product.sellerName }}</span>
        </div>
        <div class="d-flex flex-column flex-shrink-0">
          <span class="ms-auto small text-muted text-nowrap"
            >{{ product.totalSales }} lượt mua</span
          >
          <div class="ms-auto d-flex align-items-center">
            <span class="text-muted small me-1">{{ product.rating }} </span>
            <div class="text-warning">
              <i class="bi bi-star" v-if="product.rating < 1"></i
              ><i v-else-if="product.rating < 3" class="bi bi-star-half"></i
              ><i v-else class="bi bi-star-fill"></i>
            </div>
          </div>
          <button
            @click="viewProduct()"
            :disabled="!product.isActive"
            :class="[
              'btn btn-primary text-white ms-auto mt-auto',
              { 'opacity-50': !product.isActive },
            ]"
          >
            <i class="bi bi-cart-plus"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
