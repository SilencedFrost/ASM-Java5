package com.dto.seller;

import com.dto.user.UserCreateRequest;

import java.math.BigDecimal;

public record SellerCreateRequest(
        UserCreateRequest userCreateRequest,
        String shopName,
        String shopDescription
) {
}
