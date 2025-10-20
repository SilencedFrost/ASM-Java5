<script setup>
import axios from 'axios'
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/authStore'

const router = useRouter()
const authStore = useAuthStore()

const account = ref(null)
const passwordRetype = ref('')
const isLoading = ref(false)
const error = ref(null)
const fieldErrors = ref({})

async function loadData() {
  isLoading.value = true
  error.value = null

  try {
    const response = await axios.get(import.meta.env.VITE_API_BASE + '/users/account', {
      withCredentials: true,
    })
    account.value = response.data
    account.value.password = ''
  } catch (err) {
    console.error(err)
    authStore.clearUser()
    router.push('auth/login?redirect=/account')
  } finally {
    isLoading.value = false
  }
}

async function handleSave() {
  error.value = null
  fieldErrors.value = {}

  if (passwordRetype.value !== account.value.password) {
    fieldErrors.value.passwordRetype = 'Passwords do not match'
    return
  }

  passwordRetype.value = ''
  isLoading.value = true

  const payload = { ...account.value }
  Object.entries(payload).forEach(([k, v]) => {
    if (v === '') payload[k] = null
  })

  try {
    const response = await axios.put(import.meta.env.VITE_API_BASE + '/users/account', payload, {
      withCredentials: true,
    })
    account.value = response.data
  } catch (err) {
    if (err.response && err.response.data) {
      fieldErrors.value = err.response.data
    }
  } finally {
    isLoading.value = false
  }
}

onMounted(loadData)
</script>

<template>
  <div class="flex-fill p-3">
    <h2 class="fw-bold">My account</h2>
    <div v-if="isLoading" class="alert alert-info">Loading info...</div>
    <div v-if="error" class="alert alert-danger">
      {{ error }}
    </div>
    <form v-if="account" @submit.prevent="handleSave" novalidate>
      <div class="row">
        <div class="col-md-8">
          <div class="mb-3">
            <label class="form-label" for="username">Username</label>
            <input
              class="form-control"
              type="text"
              id="username"
              v-model="account.username"
              :disabled="isLoading"
            />
            <div v-if="fieldErrors.username" class="form-text text-danger">
              {{ fieldErrors.username }}
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label" for="firstName">First name</label>
            <input
              type="text"
              class="form-control"
              id="firstName"
              v-model="account.firstName"
              :disabled="isLoading"
            />
            <div v-if="fieldErrors.firstName" class="form-text text-danger">
              {{ fieldErrors.firstName }}
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label" for="lastName">Last name</label>
            <input
              type="text"
              class="form-control"
              id="lastName"
              v-model="account.lastName"
              :disabled="isLoading"
            />
            <div v-if="fieldErrors.lastName" class="form-text text-danger">
              {{ fieldErrors.lastName }}
            </div>
          </div>
          <hr />
          <div class="mb-3">
            <label class="form-label" for="email">Email:</label>
            <div class="d-flex align-items-center">
              <div class="form-control bg-light border-0" id="email">
                {{ account.email }}
              </div>
            </div>
          </div>
          <hr />
          <div class="mb-3">
            <label class="form-label" for="password">Password</label>
            <div class="d-flex align-items-center">
              <input
                type="password"
                class="form-control"
                id="password"
                v-model="account.password"
                :disabled="isLoading"
              />
            </div>
            <div v-if="fieldErrors.password" class="form-text text-danger">
              {{ fieldErrors.password }}
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label" for="passwordRetype">Password retype</label>
            <div class="d-flex align-items-center">
              <input
                type="password"
                class="form-control"
                id="passwordRetype"
                v-model="passwordRetype"
                :disabled="isLoading"
              />
            </div>
            <div v-if="fieldErrors.passwordRetype" class="form-text text-danger">
              {{ fieldErrors.passwordRetype }}
            </div>
          </div>
          <hr />
          <div class="mb-3">
            <label class="form-label" for="phoneNumber">Phone number</label>
            <div class="d-flex align-items-center">
              <input
                type="text"
                class="form-control"
                id="phoneNumber"
                v-model="account.phoneNumber"
                :disabled="isLoading"
              />
            </div>
            <div v-if="fieldErrors.phoneNumber" class="form-text text-danger">
              {{ fieldErrors.phoneNumber }}
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label" for="birthday">Birthday</label>
            <input
              type="date"
              class="form-control"
              id="birthday"
              v-model="account.birthday"
              :disabled="isLoading"
            />
            <div v-if="fieldErrors.birthday" class="form-text text-danger">
              {{ fieldErrors.birthday }}
            </div>
          </div>
          <button type="submit" class="btn btn-primary text-light w-100" :disabled="isLoading">
            <span
              v-if="isLoading"
              class="spinner-border spinner-border-sm me-2"
              role="status"
            ></span>
            {{ isLoading ? 'Đang lưu...' : 'Lưu thay đổi' }}
          </button>
        </div>
        <div class="col-md-4">
          <div class="d-flex flex-column align-items-center">
            <div
              class="border rounded p-3 text-center mb-3 bg-light"
              style="width: 120px; height: 150px"
            >
              <img
                v-if="account.avatarUrl"
                :src="account.avatarUrl"
                alt="Ảnh đại diện"
                style="width: 100%; height: 100%; object-fit: cover"
              />
              <span v-else class="text-muted">Ảnh đại diện</span>
            </div>
            <div class="text-center mb-4">
              <small class="text-muted text-center">
                Dung lượng file tối đa 1 MB<br />
                Định dạng: .JPEG, .PNG
              </small>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>
