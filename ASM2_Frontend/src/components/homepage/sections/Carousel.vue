<script setup></script>
<template>
  <!-- Promotion Carousel -->
  <section class="py-5 bg-white">
    <div class="container-fluid">
      <div class="text-center mb-4">
        <h2 class="fw-bold">🔥 Ưu đãi hấp dẫn</h2>
        <p class="text-muted">Khuyến mãi đặc biệt - Số lượng có hạn</p>
      </div>
      <div id="promotionCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-indicators">
          <button
            type="button"
            data-bs-target="#promotionCarousel"
            data-bs-slide-to="0"
            class="active"
          ></button>
          <button type="button" data-bs-target="#promotionCarousel" data-bs-slide-to="1"></button>
          <button type="button" data-bs-target="#promotionCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner rounded shadow">
          <!-- Slide 1: iPhone 15 Pro Max -->
          <div class="carousel-item active">
            <div
              class="text-white p-5"
              style="
                background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
                min-height: 400px;
              "
            >
              <div class="row align-items-center h-100">
                <div class="col-lg-6">
                  <span class="badge bg-danger fs-6 px-3 py-2 mb-3">🔥 HOT DEAL</span>
                  <h2 class="fw-bold mb-3">iPhone 15 Pro Max</h2>
                  <h3 class="text-warning mb-3">Giảm ngay 3.000.000₫</h3>
                  <div class="mb-4">
                    <span class="h4 text-decoration-line-through opacity-75 me-3">32.990.000₫</span>
                    <span class="h2 fw-bold text-warning">29.990.000₫</span>
                  </div>
                  <button class="btn btn-warning btn-lg px-4 fw-bold">
                    <i class="bi bi-cart-plus me-2"></i>MUA NGAY
                  </button>
                </div>
                <div class="col-lg-6 text-center">
                  <img
                    src="https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop"
                    alt="iPhone 15 Pro Max"
                    class="img-fluid"
                    style="max-height: 350px"
                  />
                </div>
              </div>
            </div>
          </div>
          <!-- Slide 2: Samsung Galaxy S24 Ultra -->
          <div class="carousel-item">
            <div
              class="text-white p-5"
              style="
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 400px;
              "
            >
              <div class="row align-items-center h-100">
                <div class="col-lg-6">
                  <span class="badge bg-success fs-6 px-3 py-2 mb-3">⚡ FLASH SALE</span>
                  <h2 class="fw-bold mb-3">Samsung Galaxy S24 Ultra</h2>
                  <h3 class="text-warning mb-3">Ưu đãi lên đến 4.000.000₫</h3>
                  <div class="mb-4">
                    <span class="h4 text-decoration-line-through opacity-75 me-3">29.990.000₫</span>
                    <span class="h2 fw-bold text-warning">26.990.000₫</span>
                  </div>
                  <button class="btn btn-warning btn-lg px-4 fw-bold">
                    <i class="bi bi-lightning-fill me-2"></i>MUA NGAY
                  </button>
                </div>
                <div class="col-lg-6 text-center">
                  <img
                    src="https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&h=400&fit=crop"
                    alt="Samsung Galaxy S24 Ultra"
                    class="img-fluid"
                    style="max-height: 350px"
                  />
                </div>
              </div>
            </div>
          </div>
          <!-- Slide 3: MacBook Air M3 -->
          <div class="carousel-item">
            <div
              class="text-white p-5"
              style="
                background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
                min-height: 400px;
              "
            >
              <div class="row align-items-center h-100">
                <div class="col-lg-6">
                  <span class="badge bg-info fs-6 px-3 py-2 mb-3">💎 PREMIUM</span>
                  <h2 class="fw-bold mb-3">MacBook Air M3</h2>
                  <h3 class="text-warning mb-3">Giảm sốc 5.000.000₫</h3>
                  <div class="mb-4">
                    <span class="h4 text-decoration-line-through opacity-75 me-3">33.990.000₫</span>
                    <span class="h2 fw-bold text-warning">28.990.000₫</span>
                  </div>
                  <button class="btn btn-warning btn-lg px-4 fw-bold">
                    <i class="bi bi-laptop me-2"></i>MUA NGAY
                  </button>
                </div>
                <div class="col-lg-6 text-center">
                  <img
                    src="https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400&h=400&fit=crop"
                    alt="MacBook Air M3"
                    class="img-fluid"
                    style="max-height: 350px"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
        <button
          class="carousel-control-prev"
          type="button"
          data-bs-target="#promotionCarousel"
          data-bs-slide="prev"
        >
          <span class="carousel-control-prev-icon"></span>
        </button>
        <button
          class="carousel-control-next"
          type="button"
          data-bs-target="#promotionCarousel"
          data-bs-slide="next"
        >
          <span class="carousel-control-next-icon"></span>
        </button>
      </div>
    </div>
  </section>
</template>
