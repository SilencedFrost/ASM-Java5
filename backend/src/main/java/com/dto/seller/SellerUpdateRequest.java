package com.dto.seller;

import com.dto.user.UserUpdateRequest;

import java.math.BigDecimal;

public record SellerUpdateRequest(
        Long sellerId,
        UserUpdateRequest user,
        String shopName,
        String shopDescription,
        BigDecimal rating,
        Long totalSales
) {
}
