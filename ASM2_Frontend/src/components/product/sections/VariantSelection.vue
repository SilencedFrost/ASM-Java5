<script setup>
import { defineProps, defineEmits, computed, ref, watch } from 'vue'

const props = defineProps({
  productVariations: {
    type: Array,
    required: true,
  },
})

const emit = defineEmits(['variation-selected'])

const selectedProduct = computed(() => {
  if (!props.productVariations || !selectedSize.value || !selectedVariant.value) {
    return null
  }

  return props.productVariations.find(
    (p) => p.productSize === selectedSize.value && p.variation === selectedVariant.value,
  )
})

const sizes = ref([])
const variants = ref([])

const selectedSize = ref(null)
const selectedVariant = ref(null)

function deriveVariations(productVariations) {
  sizes.value = [...new Set(productVariations.map((p) => p.productSize))]
  variants.value = [...new Set(productVariations.map((p) => p.variation))]
  selectedSize.value = sizes.value[0]
  selectedVariant.value = variants.value[0]
}

watch(
  () => props.productVariations,
  (newVal) => {
    if (newVal && newVal.length > 0) {
      deriveVariations(newVal)
    }
  },
  { immediate: true },
)

watch(
  selectedProduct,
  (variation) => {
    if (variation) {
      emit('variation-selected', variation)
    }
  },
  { immediate: true },
)
</script>

<template>
  <div v-if="sizes.length > 1">
    <label class="d-block form-label">Size:</label>
    <div class="btn-group border" role="group">
      <button
        v-for="size in sizes"
        :key="size"
        @click="selectedSize = size"
        :class="['btn', selectedSize === size ? 'btn-warning text-white' : 'btn-light']"
      >
        {{ size }}
      </button>
    </div>
  </div>
  <div v-if="variants.length > 1">
    <label class="d-block form-label">Variant:</label>
    <div class="btn-group border" role="group">
      <button
        v-for="variant in variants"
        :key="variant"
        @click="selectedVariant = variant"
        :class="['btn', selectedVariant === variant ? 'btn-warning text-white' : 'btn-light']"
      >
        {{ variant }}
      </button>
    </div>
  </div>
</template>
