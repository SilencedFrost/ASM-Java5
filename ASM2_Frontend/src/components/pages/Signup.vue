<template>
  <div class="container d-flex justify-content-center align-items-center min-vh-100 py-4">
    <div class="card shadow-sm p-4" style="max-width: 500px; width: 100%;">
      <h3 class="mb-4 text-center text-success">Đăng ký tài khoản</h3>
      
      <form @submit.prevent="onRegister">
        <div class="row">
          <div class="col-md-6 mb-3">
            <label for="firstName" class="form-label">Họ <span class="text-danger">*</span></label>
            <input
              type="text"
              id="firstName"
              v-model="form.firstName"
              class="form-control"
              required
              :disabled="isLoading"
            />
          </div>
          
          <div class="col-md-6 mb-3">
            <label for="lastName" class="form-label">Tên <span class="text-danger">*</span></label>
            <input
              type="text"
              id="lastName"
              v-model="form.lastName"
              class="form-control"
              required
              :disabled="isLoading"
            />
          </div>
        </div>

        <div class="mb-3">
          <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
          <input
            type="text"
            id="username"
            v-model="form.username"
            class="form-control"
            required
            minlength="3"
            :disabled="isLoading"
          />
          <div class="form-text">Tên đăng nhập phải có ít nhất 3 ký tự</div>
        </div>

        <div class="mb-3">
          <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
          <input
            type="email"
            id="email"
            v-model="form.email"
            class="form-control"
            required
            :disabled="isLoading"
          />
        </div>

        <div class="mb-3">
          <label for="phone" class="form-label">Số điện thoại</label>
          <input
            type="tel"
            id="phone"
            v-model="form.phone"
            class="form-control"
            :disabled="isLoading"
          />
        </div>

        <div class="row">
          <div class="col-md-6 mb-3">
            <label for="password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
            <div class="input-group">
              <input
                :type="showPassword ? 'text' : 'password'"
                id="password"
                v-model="form.password"
                class="form-control"
                required
                minlength="6"
                :disabled="isLoading"
              />
            </div>
            <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
          </div>
          
          <div class="col-md-6 mb-3">
            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
            <input
              type="password"
              id="confirmPassword"
              v-model="form.confirmPassword"
              class="form-control"
              required
              :disabled="isLoading"
            />
          </div>
        </div>

        <div class="mb-3 form-check">
          <input
            type="checkbox"
            id="agreeTerms"
            v-model="form.agreeTerms"
            class="form-check-input"
            required
            :disabled="isLoading"
          />
          <label for="agreeTerms" class="form-check-label">
            Tôi đồng ý với <a href="#" target="_blank">Điều khoản sử dụng</a> 
            và <a href="#" target="_blank">Chính sách bảo mật</a>
            <span class="text-danger">*</span>
          </label>
        </div>

        <button type="submit" class="btn btn-success w-100 mb-3" :disabled="isLoading || !isFormValid">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          <i v-else class="bi bi-person-plus me-2"></i>
          {{ isLoading ? 'Đang đăng ký...' : 'Đăng ký tài khoản' }}
        </button>
      </form>

      <div class="text-center">
        <span class="text-muted">Đã có tài khoản? </span>
        <router-link to="/login" class="text-decoration-none">Đăng nhập ngay</router-link>
      </div>

      <div class="text-center mt-3">
        <div class="d-flex align-items-center">
          <hr class="flex-grow-1">
          <span class="mx-3 text-muted">HOẶC</span>
          <hr class="flex-grow-1">
        </div>
      </div>

      <button class="btn btn-danger w-100 mt-3" @click="registerWithGoogle" :disabled="isLoading">
        <i class="fab fa-google me-2"></i> 
        Đăng ký bằng Google
      </button>

      <!-- Success message -->
      <div v-if="success" class="alert alert-success mt-3 py-2">
        <i class="bi bi-check-circle me-2"></i>
        {{ success }}
      </div>
      
      <!-- Error message -->
      <div v-if="error" class="alert alert-danger mt-3 py-2">
        <i class="bi bi-exclamation-triangle me-2"></i>
        {{ error }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Register",
  data() {
    return {
      form: {
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        phone: '',
        password: '',
        confirmPassword: '',
        agreeTerms: false
      },
      isLoading: false,
      showPassword: false,
      success: '',
      error: ''
    };
  },
  
  mounted() {
    // Kiểm tra nếu đã đăng nhập thì chuyển về trang chủ
    const savedUser = localStorage.getItem('user');
    if (savedUser) {
      this.$router.push('/');
    }
  },
  
  computed: {
    isFormValid() {
      return (
        this.form.firstName &&
        this.form.lastName &&
        this.form.username &&
        this.form.email &&
        this.form.password &&
        this.form.confirmPassword &&
        this.form.agreeTerms &&
        this.form.password === this.form.confirmPassword &&
        this.form.password.length >= 6
      );
    }
  },
  
  methods: {
    async onRegister() {
      this.error = '';
      this.success = '';
      
      // Validate form
      if (!this.validateForm()) {
        return;
      }
      
      this.isLoading = true;
      
      try {
        // Gọi API đăng ký
        const registerRes = await fetch('/api/register', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            firstName: this.form.firstName,
            lastName: this.form.lastName,
            username: this.form.username,
            email: this.form.email,
            phone: this.form.phone,
            password: this.form.password
          })
        });
        
        if (!registerRes.ok) {
          const errorData = await registerRes.json();
          this.error = errorData.message || 'Có lỗi xảy ra khi đăng ký!';
          return;
        }
        
        const registerData = await registerRes.json();
        this.success = 'Đăng ký thành công! Đang đăng nhập...';
        
        // Tự động đăng nhập sau khi đăng ký thành công
        setTimeout(async () => {
          try {
            const loginRes = await fetch('/api/login', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json'
              },
              credentials: 'include',
              body: JSON.stringify({
                username: this.form.username,
                password: this.form.password
              })
            });
            
            if (!loginRes.ok) {
              this.error = 'Đăng ký thành công nhưng không thể đăng nhập tự động. Vui lòng đăng nhập thủ công.';
              setTimeout(() => {
                this.$router.push('/login');
              }, 2000);
              return;
            }
            
            const loginData = await loginRes.json();
            
            // Lưu thông tin user vào localStorage
            const userData = {
              id: loginData.id || registerData.id,
              username: this.form.username,
              email: this.form.email,
              firstName: this.form.firstName,
              lastName: this.form.lastName,
              phone: this.form.phone,
              name: `${this.form.firstName} ${this.form.lastName}`,
              token: loginData.token,
              ...loginData
            };
            
            localStorage.setItem('user', JSON.stringify(userData));
            
            // Hiển thị thông báo thành công và chuyển về trang chủ
            this.success = 'Đăng ký và đăng nhập thành công! Đang chuyển về trang chủ...';
            
            setTimeout(() => {
              this.$router.push('/');
              // Reload để navbar cập nhật trạng thái
              window.location.reload();
            }, 1500);
            
          } catch (loginError) {
            console.error('Auto login error:', loginError);
            this.error = 'Đăng ký thành công nhưng có lỗi khi đăng nhập tự động. Vui lòng đăng nhập thủ công.';
            setTimeout(() => {
              this.$router.push('/login');
            }, 2000);
          }
        }, 1000);
        
      } catch (err) {
        console.error('Registration error:', err);
        this.error = 'Có lỗi xảy ra, vui lòng thử lại!';
      } finally {
        this.isLoading = false;
      }
    },
    
    validateForm() {
      if (!this.form.firstName.trim()) {
        this.error = 'Vui lòng nhập họ';
        return false;
      }
      
      if (!this.form.lastName.trim()) {
        this.error = 'Vui lòng nhập tên';
        return false;
      }
      
      if (!this.form.username.trim() || this.form.username.length < 3) {
        this.error = 'Tên đăng nhập phải có ít nhất 3 ký tự';
        return false;
      }
      
      if (!this.form.email.trim() || !this.isValidEmail(this.form.email)) {
        this.error = 'Vui lòng nhập email hợp lệ';
        return false;
      }
      
      if (!this.form.password || this.form.password.length < 6) {
        this.error = 'Mật khẩu phải có ít nhất 6 ký tự';
        return false;
      }
      
      if (this.form.password !== this.form.confirmPassword) {
        this.error = 'Mật khẩu xác nhận không khớp';
        return false;
      }
      
      if (!this.form.agreeTerms) {
        this.error = 'Bạn phải đồng ý với điều khoản sử dụng';
        return false;
      }
      
      return true;
    },
    
    isValidEmail(email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return emailRegex.test(email);
    },
    
    registerWithGoogle() {
      window.location.href = '/api/register/google';
    }
  }
};
</script>