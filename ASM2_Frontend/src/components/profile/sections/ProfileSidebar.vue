<script setup></script>
<template>
  <div class="flex-fill bg-secondary">
    <div class="d-flex flex-column p-3">
      <ul class="nav nav-pills flex-column">
        <li class="nav-item mb-1">
          <router-link to="/account" class="nav-link text-light d-flex align-items-center">
            <i class="bi bi-person-badge-fill text-warning me-2"></i>
             Hồ sơ
          </router-link>
        </li>
        <li class="nav-item mb-1">
          <router-link to="/account/payment" class="nav-link text-light" active-class="active">
            <i class="bi bi-bank text-warning me-2"></i>
            Ngân hàng
          </router-link>
        </li>
        <li class="nav-item mb-1">
          <router-link to="/account/address" class="nav-link text-light" active-class="active">
            <i class="bi bi-house-add-fill text-warning me-2"></i>
            Địa chỉ
          </router-link>
        </li>
        <li class="nav-item">
          <router-link to="/account/change-pass" class="nav-link text-light" active-class="active">
            <i class="bi bi-key-fill text-warning me-2"></i>
            Đổi mật khẩu
          </router-link>
        </li>
      </ul>
    </div>
  </div>
</template>