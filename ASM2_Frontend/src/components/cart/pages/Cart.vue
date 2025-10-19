<template>
  <div class="bg-light min-vh-100 py-4 flex-fill">
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
                class="btn btn-outline-secondary btn-sm"
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
                  <th class="border-0 py-3 text-dark">Sản phẩm</th>
                  <th class="border-0 py-3 text-center text-dark">Giá</th>
                  <th class="border-0 py-3 text-center text-dark">Số lượng</th>
                  <th class="border-0 py-3 text-center text-dark">Tổng</th>
                  <th class="border-0 py-3 text-center text-dark">Thao tác</th>
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
                    <span class="fw-bold text-dark">{{ formatCurrency(item.price) }}</span>
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
                        class="form-control form-control-sm text-center fw-bold text-dark"
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
                    <span class="fw-bold text-primary fs-5">{{
                      formatCurrency(item.price * item.quantity)
                    }}</span>
                  </td>
                  <td class="border-0 py-4 text-center">
                    <button class="btn btn-secondary btn-sm" @click="removeItem(item.id)">
                      Xóa
                    </button>
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
                    <span class="fw-bold text-secondary">{{ formatCurrency(item.price) }}</span>
                    <button class="btn btn-secondary btn-sm" @click="removeItem(item.id)">
                      Xóa
                    </button>
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
                  <span class="fw-bold text-dark">{{ formatCurrency(subtotal) }}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                  <span class="text-muted">Phí vận chuyển:</span>
                  <span class="text-secondary fw-bold">Miễn phí</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                  <span class="text-muted">Thuế VAT (10%):</span>
                  <span class="fw-bold text-dark">{{ formatCurrency(subtotal * 0.1) }}</span>
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
                  <button class="btn btn-primary text-light btn-lg fw-bold" @click="checkout">
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
        <div class="alert alert-primary border-0 shadow-sm mt-4" role="alert">
          <div class="d-flex">
            <div class="me-3">
              <i class="fas fa-truck fa-2x text-primary"></i>
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
            <button
              class="btn btn-primary text-light fw-bold btn-lg px-4"
              @click="continueShopping"
            >
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
import axios from 'axios'

export default {
  name: 'Cart',
  data() {
    return {
      cartItems: [],
      loading: false,
      error: null,
      userId: 100005,
    }
  },
  computed: {
    subtotal() {
      return this.cartItems.reduce((total, item) => total + item.price * item.quantity, 0)
    },
    totalPrice() {
      const tax = this.subtotal * 0.1
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

    async fetchCart() {
      this.loading = true
      this.error = null
      
      try {
        const cartRes = await axios.get(
          `${import.meta.env.VITE_API_BASE}/cart/${this.userId}`
        )
        
        console.log('Cart response:', cartRes.data)
        
        const enrichedItems = await Promise.all(
          cartRes.data.map(async (cartItem) => {
            try {
              const productRes = await axios.get(
                `${import.meta.env.VITE_API_BASE}/products/${cartItem.productId}`
              )
              
              const product = productRes.data
              
              const variation = product.productVariations?.find(
                v => v.variationId === cartItem.variationId
              ) || product.productVariations?.[0]
              
              return {
                id: cartItem.cartId,
                cartId: cartItem.cartId,
                productId: cartItem.productId,
                variationId: cartItem.variationId,
                name: product.productName || 'Sản phẩm',
                image: product.thumbnailExtension
                  ? `${import.meta.env.VITE_API_BASE}/images/products/${product.productId}.${product.thumbnailExtension}`
                  : '/placeholder.jpg',
                price: variation?.price || 0,
                quantity: cartItem.quantity,
                dateAdded: cartItem.dateAdded,
              }
            } catch (err) {
              console.error(`Lỗi load product ${cartItem.productId}:`, err)
              return {
                id: cartItem.cartId,
                cartId: cartItem.cartId,
                productId: cartItem.productId,
                variationId: cartItem.variationId,
                name: `Sản phẩm #${cartItem.productId}`,
                image: '/placeholder.jpg',
                price: 0,
                quantity: cartItem.quantity,
                dateAdded: cartItem.dateAdded,
              }
            }
          })
        )
        
        this.cartItems = enrichedItems
        console.log('Enriched cart items:', this.cartItems)
        
      } catch (err) {
        console.error('Lỗi tải giỏ hàng:', err)
        this.error = 'Không thể tải dữ liệu giỏ hàng'
        
        this.loadMockData()
      } finally {
        this.loading = false
      }
    },

    loadMockData() {
      this.cartItems = [
        {
          id: 1,
          productId: 100000,
          name: 'Trà sữa trân châu đường đen',
          image: '/placeholder.jpg',
          price: 35000,
          quantity: 2,
        },
        {
          id: 2,
          productId: 100001,
          name: 'Trà sữa matcha',
          image: '/placeholder.jpg',
          price: 36000,
          quantity: 1,
        },
        {
          id: 3,
          productId: 100004,
          name: 'Phở bò tái',
          image: '/placeholder.jpg',
          price: 50000,
          quantity: 3,
        },
      ]
    },

    async updateQuantity(item) {
      if (item.quantity < 1) {
        item.quantity = 1
        return
      }

      try {
        await axios.put(
          `${import.meta.env.VITE_API_BASE}/cart/${this.userId}/product/${item.productId}`,
          { quantity: item.quantity }
        )
        console.log('Updated quantity:', item.quantity)
      } catch (err) {
        console.error('Lỗi cập nhật số lượng:', err)
        this.showToast('Không thể cập nhật số lượng', 'error')
        this.fetchCart()
      }
    },

    async increaseQuantity(item) {
      item.quantity++
      await this.updateQuantity(item)
    },

    async decreaseQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--
        await this.updateQuantity(item)
      }
    },

    async removeItem(id) {
      if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?')) {
        return
      }

      const item = this.cartItems.find((i) => i.id === id)
      if (!item) return

      try {
        await axios.delete(
          `${import.meta.env.VITE_API_BASE}/cart/${this.userId}/product/${item.productId}`
        )

        this.cartItems = this.cartItems.filter((i) => i.id !== id)
        this.showToast('Đã xóa sản phẩm khỏi giỏ hàng', 'success')
      } catch (err) {
        console.error('Lỗi xóa sản phẩm:', err)
        this.showToast('Không thể xóa sản phẩm', 'error')
      }
    },

    async clearCart() {
      if (!confirm('Bạn có chắc chắn muốn xóa tất cả sản phẩm trong giỏ hàng?')) {
        return
      }

      try {
        await axios.delete(`${import.meta.env.VITE_API_BASE}/cart/${this.userId}`)

        this.cartItems = []
        this.showToast('Đã xóa tất cả sản phẩm khỏi giỏ hàng', 'info')
      } catch (err) {
        console.error('Lỗi xóa giỏ hàng:', err)
        this.showToast('Không thể xóa giỏ hàng', 'error')
      }
    },

    checkout() {
      if (this.cartItems.length === 0) {
        alert('Giỏ hàng của bạn đang trống!')
        return
      }
      
      console.log('Checkout with items:', this.cartItems)
      alert('Chức năng thanh toán đang được phát triển...')
    },

    continueShopping() {

      console.log('Continue shopping...')

      window.location.href = '/products'
    },

    showToast(message, type = 'info') {
      console.log(`${type.toUpperCase()}: ${message}`)
      alert(message)
    },
  },

  mounted() {
    this.fetchCart()

    if (typeof window !== 'undefined' && window.bootstrap) {
      const tooltipTriggerList = [].slice.call(
        document.querySelectorAll('[data-bs-toggle="tooltip"]')
      )
      tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new window.bootstrap.Tooltip(tooltipTriggerEl)
      })
    }
  },
}
</script>
