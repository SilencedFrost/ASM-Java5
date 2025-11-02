package com.dto.cart;

import com.dto.product.ProductSummaryResponse;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record CartResponse(
        Long cartId,
        Long userId,
        Long productId,
        String productName,
        Long variationId,
        String variation,
        Integer quantity,
        BigDecimal price,
        String thumbnail,
        OffsetDateTime dateAdded
) {
}
