<script setup></script>

<template>
  <div class="d-flex flex-fill justify-content-center align-items-center bg-light py-4">
    <div class="container p-4">
      <div class="d-flex justify-content-between align-items-start mb-4">
        <div>
          <h4 class="fw-bold mb-1">Chi tiết đơn hàng</h4>
          <div class="d-flex small text-muted">
            <div class="me-3">Mã đơn hàng: #12345</div>
            <div>Ngày đặt: 5/10/2025</div>
          </div>
        </div>
        <div class="text-end">
          <span class="badge bg-primary text-dark fs-6 px-3 py-2 mb-1">Đang xử lý</span>
          <div class="small fw-semibold text-dark">Thanh toán: Chuyển khoản</div>
        </div>
      </div>

      <div class="row g-4">
        <!-- Cột trái -->
        <div class="col-md-7">
          <h6 class="fw-bold mb-2">Sản phẩm</h6>
            <div v-for="i in 2" :key="i"
              class="border rounded-3 mb-2 p-2 bg-white d-flex align-items-center justify-content-between">
              <div class="bg-secondary rounded-2 flex-shrink-0" style="width:70px; height:70px"></div>
              <div class="ms-3 flex-fill">
                <div><strong>Tên món:</strong> ụm bòa</div>
                <div class="small text-muted">Mã món ăn: SP00{{ i }}</div>
              </div>
              <div class="text-end">
                <div class="fw-semibold">1 × đ120.000</div>
                <div class="small text-muted">Thành tiền: đ120.000</div>
              </div>
            </div>

          <h6 class="fw-bold mt-3 mb-2">Ghi chú khách hàng</h6>
          <div class="border rounded-3 bg-white p-2" style="max-height: 120px; overflow-y: auto;">
            <textarea class="form-control border-0 shadow-none" rows="3"
              placeholder="Nhập ghi chú tại đây..."></textarea>
          </div>

          <h6 class="fw-bold mb-2 mt-3">Lịch sử trạng thái</h6>
          <ul class="list-group small">
            <li class="list-group-item border-0 ps-2 d-flex align-items-center">
              <span class="rounded-circle me-2"
                style="width:10px; height:10px; background:#FFA500; display:inline-block;"></span>
              05/10/2025 09:12 — Xác nhận đơn hàng
            </li>
            <li class="list-group-item border-0 ps-2 d-flex align-items-center">
              <span class="rounded-circle me-2"
                style="width:10px; height:10px; background:#FFA500; display:inline-block;"></span>
              05/10/2025 10:00 — Chuẩn bị hàng
            </li>
            <li class="list-group-item border-0 ps-2 d-flex align-items-center">
              <span class="rounded-circle me-2"
                style="width:10px; height:10px; background:#FFA500; display:inline-block;"></span>
              Đang chờ giao
            </li>
          </ul>
        </div>

        <!-- Cột phải -->
        <div class="col-md-5">
          <h6 class="fw-bold mb-2">Thông tin người nhận</h6>
          <div class="border rounded-3 p-3 mb-3 bg-white text-center">
            <div class="text-start">
              <div>Nguyễn Văn A</div>
              <div>SDT: 0909 000 000</div>
              <div>Địa chỉ: 123 Đường Lê Lợi, Q1, TP.HCM</div>
            </div>
            <button class="btn btn-dark btn-sm mt-3 px-3 mx-auto">Sửa thông tin</button>
          </div>

          <h6 class="fw-bold mt-3 mb-2">Chi tiết đơn hàng</h6>
          <div class="border rounded-3 p-3 mb-3 bg-white">
            <div class="d-flex justify-content-between">
              <span>Tổng tiền hàng</span><span>đ240.000</span>
            </div>
            <div class="d-flex justify-content-between">
              <span>Giảm giá</span><span>- đ20.000</span>
            </div>
            <div class="d-flex justify-content-between mb-2">
              <span>Phí vận chuyển</span><span>đ30.000</span>
            </div>
            <hr class="my-2" />
            <div class="d-flex justify-content-between fw-bold">
              <span>Tổng thanh toán</span><span>đ250.000</span>
            </div>
            <small>Đã thanh toán: Chưa</small>
          </div>

          <div class="d-grid gap-2">
            <button class="btn btn-primary fw-semibold text-white">Đã nhận</button>
            <button class="btn btn-warning fw-semibold text-white">Hủy đơn</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>