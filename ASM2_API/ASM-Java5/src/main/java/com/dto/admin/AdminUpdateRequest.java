package com.dto.admin;

import com.dto.user.UserResponse;
import com.dto.user.UserUpdateRequest;

public record AdminUpdateRequest(
        Long adminId,
        UserUpdateRequest userUpdateRequest
) {
}
