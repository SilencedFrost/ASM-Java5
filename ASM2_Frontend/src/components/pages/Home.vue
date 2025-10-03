<script setup>
import Sidebar from '@/components/layouts/Sidebar.vue'
import Carousel from '@/components/sections/Carousel.vue'
import ProductByCat from '@/components/sections/ProductByCat.vue'
</script>

<template>
  <div class="container-fluid g-0">
    <div class="row g-0">
      <!-- Sidebar màu cam -->
      <div class="col-md-3 col-lg-2 d-none d-md-block p-0 sidebar-wrapper">
        <div class="sidebar-header p-3 text-center">
          <h3 class="sidebar-title text-light mb-0">DANH MỤC</h3>
        </div>
        
        <nav class="sidebar-nav">
          <ul class="nav flex-column">
            <li class="nav-item" v-for="category in categories" :key="category.id">
              <a class="nav-link" href="#">
                <i class="bi bi-caret-right-fill me-2"></i>
                {{ category.name }}
              </a>
            </li>
          </ul>
        </nav>
        
        <!-- Filter section -->
        <div class="sidebar-filter p-3">
          <h6 class="text-light mb-3">LỌC THEO GIÁ</h6>
          <div class="price-filter">
            <div class="form-check" v-for="range in priceRanges" :key="range.id">
              <input class="form-check-input" type="checkbox" :id="'price-' + range.id">
              <label class="form-check-label text-light" :for="'price-' + range.id">
                {{ range.label }}
              </label>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Main Content -->
      <div class="col-md-9 col-lg-10 ms-auto main-content">
        <!-- Hero Banner thay thế Carousel -->
        <section class="hero-banner">
          <div class="hero-content text-center">
            <h1 class="hero-title">KHÁM PHÁ HƯƠNG VỊ MỚI</h1>
            <p class="hero-subtitle">Cà phê chất lượng cao với hương vị độc biệt</p>
            <button class="hero-btn">MUA NGAY</button>
          </div>
        </section>
        
        <!-- Các section sản phẩm -->
        <div class="container-fluid py-4">
          
          <!-- Sản phẩm bán chạy -->
          <section class="product-section mb-5">
            <div class="section-header mb-4">
              <h2 class="section-title">SẢN PHẨM BÁN CHẠY</h2>
            </div>
            <div class="row g-3">
              <div class="col-6 col-md-4 col-lg-3" v-for="product in bestSellerProducts" :key="product.id">
                <div class="product-card">
                  <div class="product-image">
                    <span class="product-badge bg-danger" v-if="product.isHot">HOT</span>
                    <div class="image-placeholder bg-light">
                      <i class="bi bi-cup-hot fs-1 text-secondary"></i>
                    </div>
                  </div>
                  <div class="product-info p-2">
                    <h6 class="product-name">{{ product.name }}</h6>
                    <div class="product-price">
                      <span class="current-price text-primary fw-bold">{{ formatPrice(product.price) }}</span>
                      <span class="original-price text-muted text-decoration-line-through ms-2" v-if="product.salePrice">
                        {{ formatPrice(product.salePrice) }}
                      </span>
                    </div>
                    <div class="product-rating">
                      <i class="bi bi-star-fill text-warning"></i>
                      <span class="ms-1 small">{{ product.rating }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <!-- Sản phẩm giảm giá -->
          <section class="product-section mb-5">
            <div class="section-header mb-4">
              <h2 class="section-title">SẢN PHẨM GIẢM GIÁ</h2>
            </div>
            <div class="row g-3">
              <div class="col-6 col-md-4 col-lg-3" v-for="product in saleProducts" :key="product.id">
                <div class="product-card">
                  <div class="product-image">
                    <span class="product-badge bg-success" v-if="product.discount">-{{ product.discount }}%</span>
                    <div class="image-placeholder bg-light">
                      <i class="bi bi-cup-hot fs-1 text-secondary"></i>
                    </div>
                  </div>
                  <div class="product-info p-2">
                    <h6 class="product-name">{{ product.name }}</h6>
                    <div class="product-price">
                      <span class="current-price text-primary fw-bold">{{ formatPrice(product.price) }}</span>
                      <span class="original-price text-muted text-decoration-line-through ms-2">
                        {{ formatPrice(product.originalPrice) }}
                      </span>
                    </div>
                    <div class="product-rating">
                      <i class="bi bi-star-fill text-warning"></i>
                      <span class="ms-1 small">{{ product.rating }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <!-- Sản phẩm mới -->
          <section class="product-section mb-5">
            <div class="section-header mb-4">
              <h2 class="section-title">SẢN PHẨM MỚI</h2>
            </div>
            <div class="row g-3">
              <div class="col-6 col-md-4 col-lg-3" v-for="product in newProducts" :key="product.id">
                <div class="product-card">
                  <div class="product-image">
                    <span class="product-badge bg-info" v-if="product.isNew">MỚI</span>
                    <div class="image-placeholder bg-light">
                      <i class="bi bi-cup-hot fs-1 text-secondary"></i>
                    </div>
                  </div>
                  <div class="product-info p-2">
                    <h6 class="product-name">{{ product.name }}</h6>
                    <div class="product-price">
                      <span class="current-price text-primary fw-bold">{{ formatPrice(product.price) }}</span>
                      <span class="original-price text-muted text-decoration-line-through ms-2" v-if="product.salePrice">
                        {{ formatPrice(product.salePrice) }}
                      </span>
                    </div>
                    <div class="product-rating">
                      <i class="bi bi-star-fill text-warning"></i>
                      <span class="ms-1 small">{{ product.rating }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>

        </div>
      </div>
    </div>
  </div>
</template>
