package com.dto.seller;

import com.dto.user.UserCreateRequest;

import java.math.BigDecimal;

public record SellerCreateRequest(
        UserCreateRequest user,
        String shopName,
        String shopDescription
) {
}
