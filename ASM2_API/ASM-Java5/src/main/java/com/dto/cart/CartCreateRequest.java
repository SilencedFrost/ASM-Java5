package com.dto.cart;

public record CartCreateRequest(
        Long userId,
        Long productId,
        Integer quantity
) {
}
