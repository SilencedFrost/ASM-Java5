package com.dto.admin;

import com.dto.user.UserUpdateRequest;

public record AdminUpdateRequest(
        Long adminId,
        UserUpdateRequest user
) {
}
