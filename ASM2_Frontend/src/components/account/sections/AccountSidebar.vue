<script setup></script>

<template>
  <div class="flex-fill bg-secondary text-white p-3">
    <h5 class="fw-bold">Basic</h5>
    <div class="d-flex flex-column">
      <router-link class="text-decoration-none text-white p-2" to="/account">account</router-link>
    </div>
    <h5 class="fw-bold">Info</h5>
    <div class="d-flex flex-column">
      <router-link class="text-decoration-none text-white p-2" to="/account/address"
        >address</router-link
      >
      <router-link class="text-decoration-none text-white p-2" to="/account/payment"
        >payment</router-link
      >
    </div>
  </div>
</template>
