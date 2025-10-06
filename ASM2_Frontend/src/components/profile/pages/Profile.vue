<template>
  <div class="flex-fill bg-light">
     <div class="container">
        <div class="row justify-content-center">
            <div class="col-12 p-0">
                <div class="bg-light p-4">
                    <h4 class="fw-bold mb-3">Hồ sơ của tôi</h4>
                    <p class="text-secondary mb-4">
                        Quản lý thông tin hồ sơ để bảo mật tài khoản
                    </p>

                    <div class="row">
                        <div class="col-md-8">
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label fw-medium">Tên đăng nhập:</label>
                                    <div class="form-control bg-light border-0 w-75">phucdeptrai</div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Họ tên:</label>
                                    <input type="text" class="form-control w-75">
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Email:</label>
                                    <div class="d-flex align-items-center">
                                        <input type="email" class="form-control me-2 w-75">
                                        <a href="#" class="text-primary text-decoration-none">Thay đổi</a>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Số điện thoại:</label>
                                    <div class="d-flex align-items-center">
                                        <input type="text" class="form-control me-2 w-75">
                                        <a href="#" class="text-primary text-decoration-none">Thêm</a>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Giới tính:</label>
                                    <div class="mt-2">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="male" checked>
                                            <label class="form-check-label" for="male">Nam</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="female">
                                            <label class="form-check-label" for="female">Nữ</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="other">
                                            <label class="form-check-label" for="other">Khác</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-medium">Ngày sinh:</label>
                                    <div class="d-flex">
                                        <select class="form-select me-2">
                                            <option>Ngày</option>
                                        </select>
                                        <select class="form-select me-2">
                                            <option>Tháng</option>
                                        </select>
                                        <select class="form-select">
                                            <option>Năm</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="d-flex flex-column align-items-center">
                                <div class="border rounded p-3 text-center mb-3" style="width:120px; height:150px; background-color: #f8f9fa;">
                                    <span class="text-muted">Ảnh đại diện</span>
                                </div>
                                <div class="text-center mb-4">
                                <small class="text-muted text-center">
                                    Dung lượng file tối đa 1 MB<br>
                                    Định dạng: .JPEG, .PNG
                                </small>
                                </div>

                                <div class="mt-5 w-50">
                                    <button type="submit" class="btn btn-warning text-light w-100">
                                        Lưu thay đổi
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
  </div>
</template>

<script></script>
