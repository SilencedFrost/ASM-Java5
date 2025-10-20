<template>
  <div class="flex-fill bg-light">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-12 p-0">
          <div class="bg-light p-4">
            <h4 class="fw-bold mb-3">Hồ sơ của tôi</h4>
            <p class="text-secondary mb-4">
              Quản lý thông tin hồ sơ để bảo mật tài khoản
            </p>

            <div v-if="isLoading" class="alert alert-info">
              Đang tải thông tin...
            </div>
            <div v-if="error" class="alert alert-danger">
              {{ error }}
            </div>

            <form v-if="profile" @submit.prevent="handlesave">
              <div class="row">
                <div class="col-md-8">
                  <div class="row g-2">
                    <div class="col-12">
                      <label class="form-label fw-medium">Tên đăng nhập:</label>
                      <div class="form-control bg-light border-0 w-75">{{ profile.username }}</div>
                    </div>
                    <div class="col-12">
                      <label class="form-label fw-medium">Tên:</label>
                      <input type="text" class="form-control w-75" v-model="profile.firstName" :disabled="isLoading">
                      <div v-if="fieldErrors.firstName" class="form-text text-danger">{{ fieldErrors.firstName }}
                      </div>
                    </div>
                    <div class="col-12">
                      <label class="form-label fw-medium">Họ:</label>
                      <input type="text" class="form-control w-75" v-model="profile.lastName" :disabled="isLoading">
                      <div v-if="fieldErrors.lastName" class="form-text text-danger">{{ fieldErrors.lastName }}
                      </div>
                    </div>
                    <div class="col-12">
                      <label class="form-label fw-medium">Email:</label>
                      <div class="d-flex align-items-center">
                        <input type="email" class="form-control me-2 w-75" v-model="profile.email" :disabled="isLoading"
                          readonly>
                        <a href="#" class="text-primary text-decoration-none">Thay đổi</a>
                      </div>
                      <div v-if="fieldErrors.email" class="form-text text-danger">{{ fieldErrors.email }}</div>
                    </div>

                    <div class="col-12">
                      <label class="form-label fw-medium">Số điện thoại:</label>
                      <div class="d-flex align-items-center">
                        <input type="text" class="form-control me-2 w-75" v-model="profile.phoneNumber"
                          :disabled="isLoading" readonly>
                        <a href="#" class="text-primary text-decoration-none">Thêm</a>
                      </div>
                      <div v-if="fieldErrors.phoneNumber" class="form-text text-danger">{{ fieldErrors.phoneNumber }}
                      </div>
                    </div>
                    <div class="col-12">
                      <label class="form-label fw-medium">Ngày sinh:</label>
                      <input type="date" class="form-control w-75" v-model="profile.birthday" :disabled="isLoading">
                      <div v-if="fieldErrors.dateOfBirth" class="form-text text-danger">{{ fieldErrors.birthday }}
                      </div>
                    </div>
                  </div>
                </div>

                <div class="col-md-4">
                  <div class="d-flex flex-column align-items-center">

                    <div class="border rounded p-3 text-center mb-3 bg-light" style="width:120px; height:150px;">

                      <img v-if="profile.avatarUrl" :src="profile.avatarUrl" alt="Ảnh đại diện"
                        style="width: 100%; height: 100%; object-fit: cover;">

                      <span v-else class="text-muted">Ảnh đại diện</span>

                    </div>
                    <div class="text-center mb-4">
                      <small class="text-muted text-center">
                        Dung lượng file tối đa 1 MB<br>
                        Định dạng: .JPEG, .PNG
                      </small>
                    </div>

                    <div class="mt-5 w-50">
                      <button type="submit" class="btn btn-primary text-light w-100" :disabled="isLoading">
                        <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
                        {{ isLoading ? 'Đang lưu...' : 'Lưu thay đổi' }}
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </form>

          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import axios from "axios"
import { onMounted, ref } from "vue"
import { useRouter } from "vue-router"
import { useAuthStore } from '@/stores/authStore'

const router = useRouter();
const authStore = useAuthStore();

const profile = ref(null);
const isLoading = ref(false);
const error = ref(null);
const fieldErrors = ref({});

onMounted(async () => {
  isLoading.value = true;
  error.value = null;

  try {
    const response = await axios.get(
      import.meta.env.VITE_API_BASE + '/users/profile',
      { withCredentials: true }
    )

    const data = response.data;
    if (data.birthday) {
      data.birthday = data.birthday.split('T')[0];
    }

    profile.value = response.data;
  } catch (err) {
    console.error(err);
    error.value = 'không thể tải thông tin hồ sơ. Vui lòng đăng nhập lại!';
    authStore.clearUser();
    router.push('auth/login?redirect=/account');
  } finally {
    isLoading.value = false
  }
});

const handlesave = async () => {
  isLoading.value = true;
  error.value = null;
  fieldErrors.value = {};

  try {
    const response = await axios.put(
      import.meta.env.VITE_API_BASE + '/users/profile',
      profile.value,
      { withCredentials: true }
    );

    profile.value = response.data;
  } catch (err) {
    console.error(err);
    if (err.response && err.response.data) {
      fieldErrors.value = err.response.data;
    } else {
      error.value = 'Đã xảy ra lỗi khi lưu hồ sơ.';
    }
  } finally {
    isLoading.value = false;
  }
};
</script>
