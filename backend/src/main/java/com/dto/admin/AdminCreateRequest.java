package com.dto.admin;

import com.dto.user.UserCreateRequest;

public record AdminCreateRequest(
        UserCreateRequest user
) {
}
