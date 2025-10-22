<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  cartItem: {
    type: Object,
    required: true,
  },
})

const emit = defineEmits(['remove-product'])

const imageBase = import.meta.env.VITE_IMAGE_BASE

function removeProduct(variationId) {
  emit('remove-product', variationId)
}

function formatPrice(price) {
  return price?.toLocaleString('vi-VN') || '0'
}
</script>

<template>
  <div class="card p-2 bg-light m-0 mb-2">
    <div class="d-flex">
      <div class="d-flex align-items-center pe-3 ps-2">
        <input type="checkbox" class="form-check-input" :value="props.cartItem.isSelected" />
      </div>
      <div class="ratio ratio-1x1" :style="{ width: `20%`, maxWidth: '150px' }">
        <img
          :src="imageBase + '/product/' + props.cartItem.thumbnail"
          :alt="props.cartItem.productName"
          class="rounded-2 object-fit-cover"
        />
      </div>
      <div class="d-flex flex-fill flex-column p-2">
        <h4 class="fw-bold">{{ props.cartItem.productName }}</h4>
        <div class="text-muted">Phân loại: {{ props.cartItem.variation }}</div>
        <div class="text-danger fw-bold h5">{{ formatPrice(props.cartItem.price) }}đ</div>
        <div class="d-flex align-items-center text-muted mt-auto ms-auto flex-shrink-1">
          Số lượng:
          <input
            type="number"
            class="form-control"
            style="width: 80px"
            :value="props.cartItem.quantity"
          />
        </div>
      </div>
      <div class="bg-warning d-flex" style="width: 50px">
        <button class="btn btn-danger flex-fill" @click="removeProduct(props.cartItem.variationId)">
          <i class="bi bi-trash3"></i>
        </button>
      </div>
    </div>
  </div>
</template>
