package com.product;

import java.math.BigDecimal;

public record ProductCreateRequest(
        String productName,
        Long parentId,
        Long sellerId,
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
