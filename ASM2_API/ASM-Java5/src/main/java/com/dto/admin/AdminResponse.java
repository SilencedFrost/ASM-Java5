package com.dto.admin;

import com.dto.user.UserResponse;

public record AdminResponse(
        Long adminId,
        UserResponse userResponse
) {
}
