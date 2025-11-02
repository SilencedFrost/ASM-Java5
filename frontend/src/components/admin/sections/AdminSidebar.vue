<script setup></script>

<template>
  <div class="flex-fill bg-secondary text-white p-3">
    <h5 class="fw-bold">Monitoring</h5>
    <div class="d-flex flex-column">
      <router-link class="text-decoration-none text-white p-2" to="/admin/dashboard"
        >dashboard</router-link
      >
      <router-link class="text-decoration-none text-white p-2" to="/admin/orders"
        >orders</router-link
      >
    </div>
    <h5 class="fw-bold">Manage products</h5>
    <div class="d-flex flex-column">
      <router-link class="text-decoration-none text-white p-2" to="/admin/products"
        >products</router-link
      >
    </div>
  </div>
</template>
