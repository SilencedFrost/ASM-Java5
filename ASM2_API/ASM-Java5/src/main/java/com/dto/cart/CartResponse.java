package com.dto.cart;

import java.time.OffsetDateTime;

public record CartResponse(
        Long cartId,
        Long userId,
        Long productId,
        Integer quantity,
        OffsetDateTime dateAdded
) {
}
