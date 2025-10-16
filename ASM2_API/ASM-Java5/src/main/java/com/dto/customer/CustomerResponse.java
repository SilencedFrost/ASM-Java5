package com.dto.customer;

import com.dto.user.UserResponse;

public record CustomerResponse(
        Long customerId,
        UserResponse user
) {
}
