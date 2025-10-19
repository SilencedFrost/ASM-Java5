<script setup>
import { defineProps, ref } from 'vue'

import VariantSelection from '@/components/product/sections/VariantSelection.vue'

const props = defineProps({
  product: {
    type: Object,
    required: true,
  },
})

const quantity = ref(1)

const imageBase = import.meta.env.VITE_IMAGE_BASE

const selectedProduct = ref(null)

function setVariation(variation) {
  selectedProduct.value = variation
}

function formatPrice(price) {
  return price?.toLocaleString('vi-VN') || '0'
}
</script>

<template>
  <div class="row">
    <div class="col-md-7 col-12 p-3">
      <div class="ratio ratio-1x1">
        <img
          class="img-fluid w-100 rounded-4 object-fit-cover"
          :src="imageBase + '/product/' + product.thumbnail"
        />
      </div>
    </div>
    <div class="col-md-5 col-12 p-3">
      <h2 class="fw-bold">{{ product.productName }}</h2>
      <h4 v-if="selectedProduct" class="text-danger">
        Current price: {{ formatPrice(selectedProduct.price) }}đ
      </h4>
      <variant-selection
        :product-variations="product.productVariations"
        @variation-selected="setVariation"
      />
      <div class="mb-3">
        <label class="form-label">Amount:</label>
        <input type="number" v-model.number="quantity" min="1" class="form-control w-25" />
      </div>
      <div class="btn-group" role="group">
        <button class="btn btn-primary text-white" @click="addToCart()">
          <i class="bi bi-cart-plus"></i> Thêm vào giỏ hàng
        </button>
        <button class="btn btn-success text-white" @click="addToCart()">
          <i class="bi bi-cart-plus"></i> Mua ngay
        </button>
      </div>
      <hr />
      <div class="d-flex flex-column">
        <span>Mô tả sản phẩm:</span>
        <span>{{ product.description }}</span>
      </div>
    </div>
  </div>
</template>
