<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import StatusNavbar from '@/components/order/sections/StatusNavbar.vue'

const statusHeader = ref(null)
let resizeObserver = null

const updateHeights = () => {
  if (statusHeader.value) {
    const navbarHeight = getComputedStyle(document.documentElement).getPropertyValue(
      '--navbar-height',
    )
    statusHeader.value.style.top = navbarHeight

    const statusHeight = statusHeader.value.offsetHeight
    document.documentElement.style.setProperty('--status-navbar-height', `${statusHeight}px`)
  }
}

onMounted(() => {
  updateHeights()

  if (statusHeader.value) {
    resizeObserver = new ResizeObserver(updateHeights)
    resizeObserver.observe(statusHeader.value)
  }

  const observer = new MutationObserver(updateHeights)
  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['style'],
  })
})

onBeforeUnmount(() => {
  if (resizeObserver) {
    resizeObserver.disconnect()
  }
})
</script>

<template>
  <div class="d-flex flex-column flex-fill mw-100">
    <header class="status-header"><status-navbar /></header>
    <main class="d-flex flex-fill content-with-headers d-flex flex-column justify-content-start align-items-center mw-100">
      <!-- Giữ nguyên empty state -->
      <div class="d-flex flex-column align-items-center justify-content-center text-center mb-5 text-dark max-w-300">
        <i class="bi bi-gift mb-3 text-warning" style="font-size: 80px;"></i>
        <h3 class="mb-2 fw-bold text-dark">Chưa có đơn hàng nào</h3>
        <p class="mb-0 text-secondary">Bắt đầu mua sắm!</p>
      </div>
      <!-- Dữ liệu giả bên dưới để demo scroll và layout khi có data -->
      <div class="flex-fill">
        <div class="card mb-3">
          <div class="card-header d-flex justify-content-between align-items-center">
            <span class="badge bg-primary d-flex align-items-center gap-1">
              <i class="bi bi-truck"></i>
              05 tháng 10 Đ giao
            </span>
            <span class="small text-muted">Kiên hàng từ đặt đặt giao.</span>
          </div>
          <div class="card-body d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center flex-fill">
              <img src="#" alt="Avatar" class="rounded-circle me-3 border border-2 border-warning flex-shrink-0" style="width: 60px; height: 60px;">
              <div class="flex-fill">
                <h5 class="card-title mb-1 text-dark">Nguyễn Trọng Phúc, 170, 70kg</h5>
                <p class="card-text mb-0 small text-secondary">Easy Eat > 05 tháng 10 Đ giao</p>
              </div>
            </div>
            <div class="d-flex align-items-center justify-content-end ms-3 min-w-150">
              <div class="text-center me-3 min-w-60">
                <div class="text-dark">x1</div>
                <div class="fw-bold text-primary">26.000đ</div>
              </div>
              <div class="small text-muted text-end">
                Tổng: 26.000đ
              </div>
            </div>
          </div>
        </div>
        <!-- Thêm một card giả nữa để demo scroll dài hơn -->
        <div class="card mb-3">
          <div class="card-header d-flex justify-content-between align-items-center">
            <span class="badge bg-primary d-flex align-items-center gap-1">
              <i class="bi bi-truck"></i>
              04 tháng 10 Hoàn thành
            </span>
            <span class="small text-muted">Đã giao hàng thành công.</span>
          </div>
          <div class="card-body d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center flex-fill">
              <img src="#" alt="Avatar" class="rounded-circle me-3 border border-2 border-warning flex-shrink-0" style="width: 60px; height: 60px;">
              <div class="flex-fill">
                <h5 class="card-title mb-1 text-dark">Lê Thị Hoa, 160, 55kg</h5>
                <p class="card-text mb-0 small text-secondary">Healthy Meal > 04 tháng 10 Giao nhanh</p>
              </div>
            </div>
            <div class="d-flex align-items-center justify-content-end ms-3 min-w-150">
              <div class="text-center me-3 min-w-60">
                <div class="text-dark">x2</div>
                <div class="fw-bold text-primary">26.000đ</div>
              </div>
              <div class="small text-muted text-end">
                Tổng: 52.000đ
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Phần Có thể bạn cũng thích: Horizontal scroll carousel như Shopee/TikTok -->
      <div class="d-flex flex-fill flex-column mt-5 mw-100">
        <h4 class="mb-3 fw-bold text-dark flex-fill align-items-center">Có thể bạn cũng thích</h4>
        <div class="d-flex flex-nowrap overflow-x-scroll gap-3 pb-2">
          <div class="d-flex flex-column align-items-center" style="width: 120px;" v-for="index in 10">
            <img src="#" alt="Yakitori" class="img-fluid rounded mb-2" style="height: 100px; object-fit: cover;">
            <h6 class="mb-1 text-center small text-dark fw-bold">Yakitori Đêm Sợi</h6>
            <p class="mb-0 text-center fw-bolder text-primary">45.000đ</p>
          </div>
          
        </div>
        <!-- Hàng thứ hai: Thêm carousel ngang mới với dữ liệu giả khác -->
        <div class="d-flex flex-nowrap overflow-x-scroll gap-3 pb-2 mt-4">
          <div class="d-flex flex-column align-items-center" style="width: 120px;" v-for="index in 10">
            <img src="#" alt="Phở Bò" class="img-fluid rounded mb-2" style="height: 100px; object-fit: cover;">
            <h6 class="mb-1 text-center small text-dark fw-bold">Phở Bò Nam Định</h6>
            <p class="mb-0 text-center fw-bolder text-primary">55.000đ</p>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
.status-header {
  position: fixed;
  top: var(--navbar-height, 56px);
  left: 0;
  right: 0;
  z-index: 1029;
}

.content-with-headers {
  padding-top: var(--status-navbar-height, 56px);
}
</style>
