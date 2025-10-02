<template>
  <div class="bg-white min-vh-100">
    <div class="container py-5">
      <div class="row justify-content-center">
        <div class="col-lg-8">
          <!-- Profile Information -->
          <div>
            <h4 class="mb-4 fw-bold text-primary">
              <i class="fas fa-user-circle me-2"></i>
              Thông tin cá nhân
            </h4>
            <div class="row g-4">
              <!-- User ID -->
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label fw-bold text-secondary">
                    <i class="fas fa-id-badge me-2"></i>ID người dùng
                  </label>
                  <div class="p-3 bg-light rounded border">
                    {{ user.UserId }}
                  </div>
                </div>
              </div>

              <!-- Username -->
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label fw-bold text-secondary">
                    <i class="fas fa-user me-2"></i>Tên người dùng
                  </label>
                  <div class="p-3 bg-light rounded border">
                    {{ user.Username }}
                  </div>
                </div>
              </div>

              <!-- Email -->
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label fw-bold text-secondary">
                    <i class="fas fa-envelope me-2"></i>Email
                  </label>
                  <div class="p-3 bg-light rounded border">
                    {{ user.Email }}
                  </div>
                </div>
              </div>

              <!-- Creation Date -->
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label fw-bold text-secondary">
                    <i class="fas fa-calendar-plus me-2"></i>Ngày tạo tài khoản
                  </label>
                  <div class="p-3 bg-light rounded border">
                    {{ formatDate(user.CreationDate) }}
                  </div>
                </div>
              </div>

              <!-- Last Login Date -->
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label fw-bold text-secondary">
                    <i class="fas fa-clock me-2"></i>Lần đăng nhập cuối
                  </label>
                  <div class="p-3 bg-light rounded border">
                    {{ user.LastLoginDate ? formatDate(user.LastLoginDate) : 'Chưa đăng nhập' }}
                  </div>
                </div>
              </div>

              <!-- Account Age -->
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label fw-bold text-secondary">
                    <i class="fas fa-hourglass-half me-2"></i>Thời gian sử dụng
                  </label>
                  <div class="p-3 bg-light rounded border">
                    {{ getAccountAge(user.CreationDate) }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="row mt-4">
              <div class="col-12 text-center">
                <button class="btn btn-primary me-2 mb-2 rounded-pill px-4" @click="editProfile">
                  <i class="fas fa-edit me-2"></i>Chỉnh sửa thông tin
                </button>
                <button
                  class="btn btn-outline-secondary mb-2 rounded-pill px-4"
                  @click="changePassword"
                >
                  <i class="fas fa-key me-2"></i>Đổi mật khẩu
                </button>
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
  name: 'Profile',
  data() {
    return {
      // Sample user data based on your database schema
      user: {
        UserId: 1001,
        Username: 'john_doe',
        Email: 'john.doe@example.com',
        CreationDate: '2023-01-15T10:30:00Z',
        LastLoginDate: '2024-08-12T09:15:00Z',
      },
      defaultAvatar:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=120&h=120&fit=crop&crop=face',
    }
  },
  methods: {
    formatDate(dateString) {
      if (!dateString) return 'Không có dữ liệu'

      const date = new Date(dateString)
      const options = {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
      }

      return date.toLocaleDateString('vi-VN', options)
    },

    getAccountAge(creationDate) {
      if (!creationDate) return 'Không xác định'

      const created = new Date(creationDate)
      const now = new Date()
      const diffTime = Math.abs(now - created)
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))

      if (diffDays < 30) {
        return `${diffDays} ngày`
      } else if (diffDays < 365) {
        const months = Math.floor(diffDays / 30)
        return `${months} tháng`
      } else {
        const years = Math.floor(diffDays / 365)
        const remainingMonths = Math.floor((diffDays % 365) / 30)
        return `${years} năm ${remainingMonths > 0 ? remainingMonths + ' tháng' : ''}`
      }
    },

    editProfile() {
      // Navigate to edit profile page or show edit modal
      console.log('Edit profile clicked')
      // You can implement navigation or modal logic here
      alert('Chức năng chỉnh sửa thông tin sẽ được phát triển')
    },

    changePassword() {
      // Navigate to change password page or show change password modal
      console.log('Change password clicked')
      // You can implement navigation or modal logic here
      alert('Chức năng đổi mật khẩu sẽ được phát triển')
    },

    // Method to load user data from API
    async loadUserData() {
      try {
        // Replace this with your actual API call
        // const response = await fetch('/api/user/profile');
        // const userData = await response.json();
        // this.user = userData;

        console.log('Loading user data...')
      } catch (error) {
        console.error('Error loading user data:', error)
      }
    },
  },

  mounted() {
    // Load user data when component is mounted
    this.loadUserData()
  },
}
</script>
