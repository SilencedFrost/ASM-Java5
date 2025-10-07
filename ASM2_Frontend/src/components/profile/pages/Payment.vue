<script setup></script>

<template>
<div class="flex-fill bg-light">
    <div class="container">

    <!-- Thẻ Tín Dụng -->
     <!-- dữ liệu sau này dùng vòng lặp sinh ra (loop render) -->
    <div class="bg-light shadow-sm p-4 mb-4">
      <div class="d-flex justify-content-between align-items-center">
        <h5 class="fw-semibold mb-0">Thẻ Tín Dụng/Ghi nợ</h5>
        <button class="btn btn-primary text-light fw-semibold px-3 py-1">
          + Thêm thẻ mới
        </button>
      </div>
      <hr class="mt-3">
      <div style="max-height: 200px; overflow-y: auto;">
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>Vietcombank</strong> - **** 1234</span>
            <small class="text-muted">Visa</small>
          </div>
        </div>
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>Techcombank</strong> - **** 5678</span>
            <small class="text-muted">MasterCard</small>
          </div>
        </div>
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>ACB</strong> - **** 9988</span>
            <small class="text-muted">Visa</small>
          </div>
        </div>
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>MB Bank</strong> - **** 7744</span>
            <small class="text-muted">MasterCard</small>
          </div>
        </div>
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>VPBank</strong> - **** 2222</span>
            <small class="text-muted">Visa</small>
          </div>
        </div>
      </div>
    </div>

    <!-- Ngân hàng -->
    <div class="bg-light shadow-sm p-4 mb-4">
      <div class="d-flex justify-content-between align-items-center">
        <h5 class="fw-semibold mb-0">Tài khoản Ngân Hàng của tôi</h5>
        <button class="btn btn-primary text-light fw-semibold px-3 py-1">
          + Thêm Ngân Hàng liên kết
        </button> 
      </div>
      <hr class="mt-3">
      <div style="max-height: 200px; overflow-y: auto;">
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>Ngân hàng VietinBank</strong></span>
            <small class="text-muted">Số TK: 123456789</small>
          </div>
        </div>
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>Ngân hàng BIDV</strong></span>
            <small class="text-muted">Số TK: 987654321</small>
          </div>
        </div>
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>Ngân hàng TPBank</strong></span>
            <small class="text-muted">Số TK: 456123789</small>
          </div>
        </div>
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>Ngân hàng MB Bank</strong></span>
            <small class="text-muted">Số TK: 333333333</small>
          </div>
        </div>
        <div class="border rounded p-3 mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>Ngân hàng Agribank</strong></span>
            <small class="text-muted">Số TK: 555555555</small>
          </div>
        </div>
      </div>
    </div>

  </div>
</div>
</template>
