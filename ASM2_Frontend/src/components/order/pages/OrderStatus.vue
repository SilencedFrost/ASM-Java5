<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import StatusNavbar from '@/components/order/sections/StatusNavbar.vue'

const statusHeader = ref(null)
let resizeObserver = null

const updateHeights = () => {
  if (statusHeader.value) {
    const navbarHeight = getComputedStyle(document.documentElement).getPropertyValue(
      '--navbar-height',
    )
    statusHeader.value.style.top = navbarHeight

    const statusHeight = statusHeader.value.offsetHeight
    document.documentElement.style.setProperty('--status-navbar-height', `${statusHeight}px`)
  }
}

onMounted(() => {
  updateHeights()

  if (statusHeader.value) {
    resizeObserver = new ResizeObserver(updateHeights)
    resizeObserver.observe(statusHeader.value)
  }

  const observer = new MutationObserver(updateHeights)
  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['style'],
  })
})

onBeforeUnmount(() => {
  if (resizeObserver) {
    resizeObserver.disconnect()
  }
})
</script>

<template>
  <div class="d-flex flex-column flex-fill">
    <header class="status-header"><status-navbar /></header>
    <main class="d-flex flex-fill content-with-headers">Nội dung ở đây</main>
  </div>
</template>

<style scoped>
.status-header {
  position: fixed;
  top: var(--navbar-height, 56px);
  left: 0;
  right: 0;
  z-index: 1029;
}

.content-with-headers {
  padding-top: var(--status-navbar-height, 56px);
}
</style>
