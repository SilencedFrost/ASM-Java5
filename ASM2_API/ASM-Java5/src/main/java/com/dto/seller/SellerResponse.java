package com.dto.seller;

import com.dto.user.UserResponse;

import java.math.BigDecimal;

public record SellerResponse(
        Long sellerId,
        UserResponse userResponse,
        String shopName,
        String shopDescription,
        BigDecimal rating,
        Long totalSales
) {
}
