<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'

import ExtraProducts from '@/components/sections/ExtraProducts.vue'

const quantity = ref(1)

const imageBase = import.meta.env.VITE_IMAGE_BASE

// Lấy ID sản phẩm từ URL
const route = useRoute()
const productId = ref(route.params.id)

// Reactive state
const product = ref([])
const loading = ref(true)
const error = ref(null)

// Fetch
async function fetchCategories() {
  loading.value = true
  error.value = null
  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/products/' + productId.value)
    product.value = response.data
  } catch (err) {
    error.value = 'Failed to load data'
  } finally {
    loading.value = false
  }
}

onMounted(fetchCategories)

// Watch for route param changes
watch(
  () => route.params.id,
  (newId) => {
    productId.value = newId
    fetchCategories()
  },
)
</script>

<template>
  <div class="container-fluid p-2">
    <div v-if="loading" class="alert alert-info">Loading categories...</div>
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>
    <div v-else="">
      <div class="row">
        <div class="col-md-7 col-12">
          <img class="img-fluid w-100" :src="imageBase + '/' + product.imageUrl" />
        </div>
        <!-- Thông tin sản phẩm -->
        <div class="col-md-5 col-12">
          <h3>{{ product.name }}</h3>
          <h4 class="text-danger">Giá hiện tại: {{ product.price }}$</h4>
          <!-- Số lượng -->
          <div class="mb-3">
            <label class="form-label">Số lượng:</label>
            <input type="number" v-model.number="quantity" min="1" class="form-control w-25" />
          </div>
          <!-- Nút hành động -->
          <div class="d-flex gap-2">
            <button class="btn btn-warning" @click="addToCart()">Thêm vào giỏ hàng</button>
          </div>
        </div>
      </div>
      <!-- Tabs thông tin -->
      <div class="mt-5">
        <ul class="nav nav-tabs">
          <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#info">
              Thông tin sản phẩm
            </button>
          </li>
          <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#specs">
              Thông số kỹ thuật
            </button>
          </li>
        </ul>
        <div class="tab-content p-3 border border-top-0">
          <div class="tab-pane fade show active" id="info">
            <p>{{ product.productDescription }}</p>
          </div>
          <div class="tab-pane fade" id="specs">
            <ul>
              <li v-for="(value, key) in product.specifications" :key="key">
                <strong>{{ key }}:</strong> {{ value }}
              </li>
            </ul>
          </div>
        </div>
      </div>
      <div class="container-fluid p-0">
        <!-- Sản phẩm liên quan -->
        <extra-products :categoryId="product.categoryId" />
        <!-- Bình luận -->
        <div class="mt-5">
          <h4>Bình luận</h4>
          <div class="mb-3">
            <textarea
              v-model="newComment"
              class="form-control"
              placeholder="Viết bình luận..."
              rows="3"
            ></textarea>
          </div>
          <button class="btn btn-primary mb-4" @click="postComment">Gửi</button>
          <div v-for="(cmt, index) in comments" :key="index" class="border p-2 mb-2">
            <strong>{{ cmt.user }}</strong>
            <br />
            {{ cmt.text }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
