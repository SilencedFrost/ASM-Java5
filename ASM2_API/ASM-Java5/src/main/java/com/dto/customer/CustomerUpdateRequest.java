package com.dto.customer;

import com.dto.user.UserUpdateRequest;

public record CustomerUpdateRequest(
        Long customerId,
        UserUpdateRequest userUpdateRequest
) {
}
