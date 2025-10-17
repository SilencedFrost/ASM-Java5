package com.dto.product.variation;

import java.math.BigDecimal;

public record ProductVariationUpdateRequest(
        Long productId,
        String productName,
        Integer categoryId,
        Integer stockCount,
        String image,
        String productSize,
        String variation,
        String description,
        BigDecimal price,
        Boolean isActive
) {
}
