import { ref } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'

export const useCartStore = defineStore('cart', () => {
  const count = ref(0)

  function setCount(newCount) {
    count.value = newCount
  }

  function clearCount() {
    count.value = 0
  }

  async function checkCount() {
    try {
      const res = await axios.get(`${import.meta.env.VITE_API_BASE}/cart/count`, {
        withCredentials: true,
      })
      if (res.data && res.data.count) {
        setCount(res.data.count)
      } else {
        clearCount()
      }
    } catch (err) {
      clearCount()
    }
  }

  return {
    count,
    setCount,
    clearCount,
    checkCount,
  }
})
