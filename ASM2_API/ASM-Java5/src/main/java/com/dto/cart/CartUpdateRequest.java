package com.dto.cart;

public record CartUpdateRequest(
        Long userId,
        Integer quantity
) {
}
