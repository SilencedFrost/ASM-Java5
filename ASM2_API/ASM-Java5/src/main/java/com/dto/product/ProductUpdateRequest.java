package com.dto.product;

import java.math.BigDecimal;

public record ProductUpdateRequest(
        Long productId,
        String productName,
        Integer categoryId,
        Integer stockCount,
        String thumbnailExtension,
        String productSize,
        String variation,
        String description,
        BigDecimal price,
        Boolean isActive
) {
}
