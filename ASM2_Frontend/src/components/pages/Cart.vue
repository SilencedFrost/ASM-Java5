<template>
  <div class="bg-light min-vh-100 py-4">
    <div class="container">
      <!-- Cart Header -->
      <div class="card mb-4 border-0 shadow-sm">
        <div class="card-body">
          <div class="row align-items-center">
            <div class="col-md-8">
              <h2 class="card-title text-primary mb-1">
                <i class="fas fa-shopping-cart me-3"></i>
                Giỏ hàng của bạn
              </h2>
              <p class="text-muted mb-0">{{ cartItems.length }} sản phẩm trong giỏ hàng</p>
            </div>
            <div class="col-md-4 text-md-end mt-3 mt-md-0">
              <button
                class="btn btn-outline-danger btn-sm"
                @click="clearCart"
                v-if="cartItems.length > 0"
              >
                <i class="fas fa-trash me-2"></i>Xóa tất cả
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Cart Content -->
      <div v-if="cartItems.length > 0">
        <!-- Desktop Table View -->
        <div class="card border-0 shadow-sm d-none d-lg-block mb-4">
          <div class="table-responsive">
            <table class="table table-hover mb-0">
              <thead class="table-primary">
                <tr>
                  <th class="border-0 py-3">Sản phẩm</th>
                  <th class="border-0 py-3 text-center">Giá</th>
                  <th class="border-0 py-3 text-center">Số lượng</th>
                  <th class="border-0 py-3 text-center">Tổng</th>
                  <th class="border-0 py-3 text-center">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in cartItems" :key="item.id">
                  <td class="border-0 py-4">
                    <div class="d-flex align-items-center">
                      <div class="me-3">
                        <img
                          :src="item.image"
                          :alt="item.name"
                          class="img-fluid rounded shadow-sm"
                          style="width: 80px; height: 80px; object-fit: cover"
                        />
                      </div>
                      <div>
                        <h6 class="mb-0 fw-bold">{{ item.name }}</h6>
                        <small class="text-muted">Mã SP: #{{ item.id }}</small>
                      </div>
                    </div>
                  </td>
                  <td class="border-0 py-4 text-center">
                    <span class="fw-bold text-danger">{{ formatCurrency(item.price) }}</span>
                  </td>
                  <td class="border-0 py-4">
                    <div class="d-flex justify-content-center align-items-center">
                      <button
                        class="btn btn-outline-secondary btn-sm me-2"
                        @click="decreaseQuantity(item)"
                      >
                        -
                      </button>
                      <input
                        type="number"
                        class="form-control form-control-sm text-center fw-bold"
                        style="width: 60px"
                        v-model.number="item.quantity"
                        min="1"
                        @change="updateQuantity(item)"
                      />
                      <button
                        class="btn btn-outline-secondary btn-sm ms-2"
                        @click="increaseQuantity(item)"
                      >
                        +
                      </button>
                    </div>
                  </td>
                  <td class="border-0 py-4 text-center">
                    <span class="fw-bold text-success fs-5">{{
                      formatCurrency(item.price * item.quantity)
                    }}</span>
                  </td>
                  <td class="border-0 py-4 text-center">
                    <button class="btn btn-danger btn-sm" @click="removeItem(item.id)">Xóa</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Mobile Card View -->
        <div class="d-lg-none">
          <div v-for="item in cartItems" :key="item.id" class="card mb-3 border-0 shadow-sm">
            <div class="card-body">
              <div class="row align-items-center">
                <div class="col-4">
                  <img
                    :src="item.image"
                    :alt="item.name"
                    class="img-fluid rounded shadow-sm w-100"
                    style="height: 80px; object-fit: cover"
                  />
                </div>
                <div class="col-8">
                  <h6 class="card-title mb-1 fw-bold">{{ item.name }}</h6>
                  <small class="text-muted d-block mb-2">Mã SP: #{{ item.id }}</small>
                  <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="fw-bold text-danger">{{ formatCurrency(item.price) }}</span>
                    <button class="btn btn-danger btn-sm" @click="removeItem(item.id)">Xóa</button>
                  </div>
                  <div class="d-flex justify-content-between align-items-center">
                    <div class="btn-group" role="group">
                      <button
                        class="btn btn-outline-secondary btn-sm"
                        @click="decreaseQuantity(item)"
                      >
                        -
                      </button>
                      <span class="btn btn-outline-secondary btn-sm fw-bold">{{
                        item.quantity
                      }}</span>
                      <button
                        class="btn btn-outline-secondary btn-sm"
                        @click="increaseQuantity(item)"
                      >
                        +
                      </button>
                    </div>
                    <span class="fw-bold text-success">{{
                      formatCurrency(item.price * item.quantity)
                    }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Chi tiết thanh toán - Card riêng biệt -->
        <div class="card border-0 shadow-sm" style="margin-bottom: 3rem">
          <div class="card-body">
            <h5 class="card-title text-primary mb-3">
              <i class="fas fa-calculator me-2"></i>
              Chi tiết thanh toán
            </h5>
            <div class="row">
              <div class="col-lg-6">
                <div class="d-flex justify-content-between mb-2">
                  <span class="text-muted">Tạm tính ({{ cartItems.length }} sản phẩm):</span>
                  <span class="fw-bold">{{ formatCurrency(subtotal) }}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                  <span class="text-muted">Phí vận chuyển:</span>
                  <span class="text-success fw-bold">Miễn phí</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                  <span class="text-muted">Thuế VAT (10%):</span>
                  <span class="fw-bold">{{ formatCurrency(subtotal * 0.1) }}</span>
                </div>
              </div>
              <div class="col-lg-6">
                <div class="text-lg-end">
                  <hr class="my-3 d-lg-none" />
                  <div class="d-flex justify-content-between justify-content-lg-end">
                    <h5 class="mb-0 text-dark me-lg-3">Tổng cộng:</h5>
                    <h4 class="mb-0 text-primary fw-bold">
                      {{ formatCurrency(totalPrice) }}
                    </h4>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Nút thanh toán - Card riêng biệt -->
        <div class="card border-0 shadow-sm">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-lg-8">
                <div class="d-flex align-items-center">
                  <div class="me-4">
                    <i class="fas fa-shield-alt fa-2x text-success me-2"></i>
                    <span class="text-muted">Thanh toán an toàn & bảo mật</span>
                  </div>
                  <div>
                    <small class="text-muted d-block mb-1">Chúng tôi chấp nhận:</small>
                    <div class="d-flex">
                      <span class="badge bg-light text-dark me-1">
                        <i class="fab fa-cc-visa"></i>
                      </span>
                      <span class="badge bg-light text-dark me-1">
                        <i class="fab fa-cc-mastercard"></i>
                      </span>
                      <span class="badge bg-light text-dark me-1">
                        <i class="fas fa-mobile-alt"></i>
                      </span>
                      <span class="badge bg-light text-dark">
                        <i class="fas fa-university"></i>
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-lg-4 text-end mt-4 mt-lg-0">
                <div class="d-grid gap-2">
                  <button class="btn btn-primary btn-lg fw-bold" @click="checkout">
                    <i class="fas fa-credit-card me-2"></i>
                    Thanh toán ngay
                  </button>
                  <button class="btn btn-outline-secondary" @click="continueShopping">
                    <i class="fas fa-arrow-left me-2"></i>
                    Tiếp tục mua sắm
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Shipping Info -->
        <div class="alert alert-info border-0 shadow-sm mt-4" role="alert">
          <div class="d-flex">
            <div class="me-3">
              <i class="fas fa-truck fa-2x text-info"></i>
            </div>
            <div>
              <h6 class="alert-heading">Thông tin giao hàng</h6>
              <p class="mb-1">• Miễn phí vận chuyển cho đơn hàng trên 500,000 VND</p>
              <p class="mb-1">• Giao hàng trong 2-3 ngày làm việc</p>
              <p class="mb-0">• Hỗ trợ đổi trả trong 7 ngày</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty Cart -->
      <div v-else class="text-center py-5">
        <div class="card border-0 shadow-sm">
          <div class="card-body py-5">
            <div class="mb-4">
              <i class="fas fa-shopping-cart fa-5x text-muted"></i>
            </div>
            <h4 class="card-title text-muted mb-3">Giỏ hàng của bạn đang trống</h4>
            <p class="card-text text-muted mb-4">
              Hãy thêm một số sản phẩm vào giỏ hàng để bắt đầu mua sắm!
            </p>
            <button class="btn btn-primary btn-lg px-4" @click="continueShopping">
              <i class="fas fa-shopping-bag me-2"></i>
              Bắt đầu mua sắm
            </button>

            <!-- Suggested Categories -->
            <div class="mt-4">
              <p class="text-muted mb-3">Danh mục phổ biến:</p>
              <div class="d-flex justify-content-center flex-wrap gap-2">
                <span class="badge bg-secondary px-3 py-2">Laptop & PC</span>
                <span class="badge bg-secondary px-3 py-2">Điện thoại</span>
                <span class="badge bg-secondary px-3 py-2">Phụ kiện</span>
                <span class="badge bg-secondary px-3 py-2">Gaming</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Cart',
  data() {
    return {
      cartItems: [
        {
          id: 1,
          name: 'Dụng cụ vệ sinh Laptop',
          price: 100000,
          quantity: 2,
          image: 'https://th.bing.com/th/id/OIP.uiGb5pkwkRtTF7p9z4ZenAHaHa?rs=1&pid=ImgDetMain',
        },
        {
          id: 2,
          name: 'Hộp pin chuột không dây',
          price: 150000,
          quantity: 1,
          image:
            'https://pintrongtin.com/wp-content/uploads/2019/07/mua-pin-cho-chuot-khong-day.png',
        },
      ],
    }
  },
  computed: {
    subtotal() {
      return this.cartItems.reduce((total, item) => total + item.price * item.quantity, 0)
    },
    totalPrice() {
      const tax = this.subtotal * 0.1 // 10% VAT
      return this.subtotal + tax
    },
  },
  methods: {
    formatCurrency(value) {
      return value.toLocaleString('vi-VN', {
        style: 'currency',
        currency: 'VND',
      })
    },
    updateQuantity(item) {
      if (item.quantity < 1) item.quantity = 1
    },
    increaseQuantity(item) {
      item.quantity++
    },
    decreaseQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--
      }
    },
    removeItem(id) {
      if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?')) {
        this.cartItems = this.cartItems.filter((item) => item.id !== id)
        this.showToast('Đã xóa sản phẩm khỏi giỏ hàng', 'success')
      }
    },
    clearCart() {
      if (confirm('Bạn có chắc chắn muốn xóa tất cả sản phẩm trong giỏ hàng?')) {
        this.cartItems = []
        this.showToast('Đã xóa tất cả sản phẩm khỏi giỏ hàng', 'info')
      }
    },
    checkout() {
      // Simulate checkout process
      if (this.cartItems.length === 0) {
        alert('Giỏ hàng trống! Vui lòng thêm sản phẩm trước khi thanh toán.')
        return
      }

      // Show loading state
      const originalText = event.target.innerHTML
      event.target.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...'
      event.target.disabled = true

      setTimeout(() => {
        alert(
          `Thanh toán thành công!\nTổng tiền: ${this.formatCurrency(this.totalPrice)}\nCảm ơn bạn đã mua sắm!`,
        )
        this.cartItems = []
        event.target.innerHTML = originalText
        event.target.disabled = false
      }, 2000)
    },
    continueShopping() {
      // Navigate back to products page
      alert('Chuyển hướng về trang sản phẩm...')
      // In a real app: this.$router.push('/products');
    },
    showToast(message, type = 'info') {
      // Simple toast notification simulation
      // In a real app, you might use Bootstrap Toast or a toast library
      console.log(`${type.toUpperCase()}: ${message}`)
    },
  },
  mounted() {
    // Initialize Bootstrap tooltips if needed
    if (typeof window !== 'undefined' && window.bootstrap) {
      const tooltipTriggerList = [].slice.call(
        document.querySelectorAll('[data-bs-toggle="tooltip"]'),
      )
      tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new window.bootstrap.Tooltip(tooltipTriggerEl)
      })
    }
  },
}
</script>
