<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import axios from 'axios'
import { useRouter, useRoute } from 'vue-router'

const otp = ref('')
const isLoading = ref(false)
const message = ref('')
const router = useRouter()
const route = useRoute()
const email = ref(route.query.email || 'Email not found')

const fieldErrors = ref({})

const resendCooldown = ref(60)
let timer = null

onMounted(() => startTimer())
onUnmounted(() => clearInterval(timer))

function startTimer() {
  resendCooldown.value = 60
  clearInterval(timer)
  timer = setInterval(() => {
    if (resendCooldown.value > 0) {
      resendCooldown.value--
    } else {
      clearInterval(timer)
    }
  }, 1000)
}

async function onSubmit() {
    isLoading.value = true
    message.value = ''
    fieldErrors.value = {} 

    if (!otp.value) {
        fieldErrors.value = { otp: 'OTP code cannot be empty.' }
        isLoading.value = false
        return
    }

    try {
        const res = await axios.post(
            import.meta.env.VITE_API_BASE + '/auth/verify-otp',
            {
                otp: otp.value
            },
            { withCredentials: true })

        message.value = res.data
        
        setTimeout(() => router.push({
            path: '/auth/reset-password', 
            query: { email: email.value } 
        }), 1500)

    } catch (err) {
        if (err.response && err.response.data) {
            fieldErrors.value = { otp: err.response.data }
        } else {
            fieldErrors.value = { error: 'Cannot connect to server' }
        }
    } finally {
        isLoading.value = false
    }
}

async function resendOtp() {
  if (resendCooldown.value > 0 || isLoading.value) return 

  isLoading.value = true
  message.value = ''
  fieldErrors.value = {} 

  try {
    const res = await axios.post(
      import.meta.env.VITE_API_BASE + '/auth/forgot-password',
      { email: email.value },
      { withCredentials: true }
    )

    message.value = 'A new OTP has been sent!'
    startTimer() 
  } catch (err) {
    if (err.response && err.response.data) {
        fieldErrors.value = { error: err.response.data }
    } else {
        fieldErrors.value = { error: 'Failed to resend code.' }
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
    <div class="d-flex flex-fill justify-content-center align-items-center bg-warning min-vh-100">
        <div class="card shadow-sm p-3 bg-light" style="max-width: 400px; width: 100%">
            <h2 class="text-center text-dark">OTP Verification</h2>
            <hr />

            <form @submit.prevent="onSubmit" novalidate>
                <div class="mb-3">
                    <label for="otp" class="form-label text-dark">OTP Code</label>
                    <input type="text" 
                           id="otp" 
                           class="form-control text-center fs-5" 
                           maxlength="6" 
                           v-model="otp"
                           required 
                           :disabled="isLoading"
                           :class="{ 'is-invalid': fieldErrors.otp }" />
                    
                    <div class="form-text text-dark mt-1">
                        Enter the OTP code sent to <strong>{{ email }}</strong>.
                    </div>
                    
                    <div v-if="fieldErrors.otp" class="form-text text-danger">
                        {{ fieldErrors.otp }}
                    </div>
                </div>

                <div v-if="fieldErrors.error" class="form-text text-danger mb-3">
                    {{ fieldErrors.error }}
                </div>

                <button type="submit" class="btn w-100 btn-primary text-white" :disabled="isLoading">
                    <span v-if="isLoading" class="spinner-border spinner-border-sm me-2" role="status"></span>
                    {{ isLoading ? 'Verifying...' : 'Verify' }}
                </button>
            </form>

            <div v-if="message" class="alert alert-success mt-3 text-center">{{ message }}</div>

            <hr />
            <div class="text-center">
                <span class="text-muted">Didn't receive a code?</span>
                <button type="button" 
                        class="btn btn-link text-decoration-none ms-1 p-0"
                        style="vertical-align: baseline;"
                        @click="resendOtp"
                        :disabled="isLoading || resendCooldown > 0">
                    Resend code {{ resendCooldown > 0 ? `(${resendCooldown}s)` : '' }}
                </button>
            </div>
        </div>
    </div>
</template>