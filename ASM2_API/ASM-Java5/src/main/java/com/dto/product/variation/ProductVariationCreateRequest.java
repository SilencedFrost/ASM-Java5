package com.dto.product.variation;

import java.math.BigDecimal;

public record ProductVariationCreateRequest(
        Long productId,
        Integer stockCount,
        String image,
        String productSize,
        String variation,
        BigDecimal price
) {
}
