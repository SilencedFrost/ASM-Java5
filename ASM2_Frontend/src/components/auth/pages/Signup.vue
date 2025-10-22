<script setup>
import axios from 'axios'
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/authStore'

const authStore = useAuthStore()

const router = useRouter()

const username = ref()
const email = ref()
const phoneNumber = ref()
const password = ref()
const passwordRetype = ref()
const rememberMe = ref(false)

const isLoading = ref(false)
const fieldErrors = ref({})

const registrationSuccessMessage = ref(null)

async function onRegister() {
  fieldErrors.value = {}
  registrationSuccessMessage.value = null

  if (password.value !== passwordRetype.value) {
    fieldErrors.value.passwordRetype = 'Passwords do not match'
    return
  }

  isLoading.value = true

  try {
    const res = await axios.post(
      import.meta.env.VITE_API_BASE + '/auth/register/customer',
      {
        username: username.value,
        email: email.value,
        phoneNumber: phoneNumber.value,
        password: password.value,
        rememberMe: rememberMe.value,
      },
      { withCredentials: true },
    )

    if (res.data) {
      registrationSuccessMessage.value = res.data

      username.value = ''
      email.value = ''
      phoneNumber.value = ''
      password.value = ''
      passwordRetype.value = ''
      rememberMe.value = false
    } 

  } catch (err) {
    authStore.clearUser() 
    if (err.response && err.response.data) {
        if (typeof err.response.data === 'object' && err.response.data.error) {
            fieldErrors.value.general = err.response.data.error; 
        } 

        else if (typeof err.response.data === 'object') {
            fieldErrors.value = err.response.data
        } 

        else {
             fieldErrors.value.general = err.response.data
        }
    }
  } finally {
    isLoading.value = false
  }
}

function registerWithGoogle() {}
</script>

<template>
  <div class="d-flex flex-fill justify-content-center align-items-center">
    <div class="card shadow-sm p-4 bg-light" style="max-width: 500px; width: 100%">
      <h2 class="text-center">Register</h2>
      <hr />
      <form @submit.prevent="onRegister" novalidate>

        <div v-if="registrationSuccessMessage" class="alert alert-success">
          {{ registrationSuccessMessage }}
        </div>

        <div v-if="fieldErrors.general" class="alert alert-danger">
          {{ fieldErrors.general }}
        </div>

        <div class="mb-3">
          <label for="username" class="form-label"
            >Username<span class="text-danger">*</span></label
          >
          <input
            type="text"
            id="username"
            class="form-control"
            required
            :disabled="isLoading"
            v-model="username"
          />
          <div v-if="fieldErrors.username" class="form-text text-danger">
            {{ fieldErrors.username }}
          </div>
        </div>

        <div class="mb-3">
          <label for="email" class="form-label">Email<span class="text-danger">*</span></label>
          <input
            type="email"
            id="email"
            class="form-control"
            required
            :disabled="isLoading"
            v-model="email"
          />
          <div v-if="fieldErrors.email" class="form-text text-danger">
            {{ fieldErrors.email }}
          </div>
        </div>

        <div class="mb-3">
          <label for="phone" class="form-label"
            >Phone number<span class="text-danger">*</span></label
          >
          <input
            type="tel"
            id="phone"
            class="form-control"
            required
            :disabled="isLoading"
            v-model="phoneNumber"
          />
          <div v-if="fieldErrors.phoneNumber" class="form-text text-danger">
            {{ fieldErrors.phoneNumber }}
          </div>
        </div>

        <div class="row">
          <div class="col-md-6 mb-3">
            <label for="password" class="form-label"
              >Password<span class="text-danger">*</span></label
            >
            <div class="input-group">
              <input
                type="password"n
                id="password"
                class="form-control"
                required
                :disabled="isLoading"
                v-model="password"
              />
            </div>
            <div v-if="fieldErrors.password" class="form-text text-danger">
              {{ fieldErrors.password }}
            </div>
          </div>

          <div class="col-md-6 mb-3">
            <label for="confirmPassword" class="form-label"
              >Retype password<span class="text-danger">*</span></label
            >
            <input
              type="password"
              id="confirmPassword"
              class="form-control"
              required
              :disabled="isLoading"
              v-model="passwordRetype"
            />
            <div v-if="fieldErrors.passwordRetype" class="form-text text-danger">
              {{ fieldErrors.passwordRetype }}
            </div>
          </div>
          <div class="mb-3">
            <div>
              <input
                type="checkbox"
                id="rememberMe"
                v-model="rememberMe"
                class="form-check-input me-2"
                :disabled="isLoading"
              />
              <label for="rememberMe" class="form-check-label">Remember Me</label>
            </div>
          </div>
        </div>

        <button type="submit" class="btn btn-dark w-100" :disabled="isLoading">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
          {{ isLoading ? 'Registering...' : 'Register' }}
        </button>
      </form>

      <button
        class="btn btn-primary text-white w-100 mt-3"
        @click="registerWithGoogle"
        :disabled="isLoading"
      >
        <i class="fab fa-google me-2"></i>
        Register with Google
      </button>

      <hr />

      <div class="text-center">
        <span class="text-muted">Already have an account? </span>
        <router-link to="/auth/login" class="text-decoration-none">Login</router-link>
      </div>
    </div>
  </div>
</template>
