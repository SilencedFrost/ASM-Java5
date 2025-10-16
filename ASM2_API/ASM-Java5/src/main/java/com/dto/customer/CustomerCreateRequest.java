package com.dto.customer;

import com.dto.user.UserCreateRequest;

public record CustomerCreateRequest(
        UserCreateRequest user
) {
}
