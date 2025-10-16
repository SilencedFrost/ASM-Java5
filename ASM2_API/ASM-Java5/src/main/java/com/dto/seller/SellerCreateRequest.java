package com.dto.seller;

import com.dto.user.UserCreateRequest;

public record SellerCreateRequest(
        UserCreateRequest user,
        String shopName,
        String shopDescription
) {
}
