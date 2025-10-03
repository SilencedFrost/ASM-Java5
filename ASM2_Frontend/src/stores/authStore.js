import { ref } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'

export const useAuthStore = defineStore('auth', () => {
  const isLoggedIn = ref(false)
  const userId = ref(-1)
  const username = ref('')
  const email = ref()
  const creationDate = ref()
  const roleName = ref('')
  const isActive = ref(false)

  function setUser(user) {
    userId.value = user.userId
    username.value = user.username
    email.value = user.email
    creationDate.value = user.creationDate
    roleName.value = user.roleName
    isActive.value = user.isActive
    isLoggedIn.value = true
  }

  function clearUser() {
    userId.value = -1
    username.value = ''
    email.value = undefined
    creationDate.value = undefined
    roleName.value = ''
    isActive.value = false
    isLoggedIn.value = false
  }

  async function checkSession() {
    try {
      const res = await axios.post(
        import.meta.env.VITE_API_BASE + '/auth/login',
        {},
        {
          withCredentials: true,
        },
      )
      if (res.data && res.data.userId) {
        setUser(res.data)
      } else {
        clearUser()
      }
    } catch (err) {
      clearUser()
    }
  }

  async function logOut() {
    try {
      await axios.post(
        import.meta.env.VITE_API_BASE + '/auth/logout',
        {},
        {
          withCredentials: true,
        },
      )
    } catch (err) {
    } finally {
      clearUser()
    }
  }

  checkSession()

  return {
    isLoggedIn,
    userId,
    username,
    email,
    creationDate,
    roleName,
    isActive,
    setUser,
    clearUser,
    checkSession,
    logOut,
  }
})
