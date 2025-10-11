package com.dto.product;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record ProductResponse(
        Long productId,
        String productName,
        Long parentId,
        Long sellerId,
        Integer categoryId,
        LocalDateTime dateAdded,
        Integer stockCount,
        String thumbnailExtension,
        String productSize,
        String variation,
        String description,
        BigDecimal price,
        Boolean isActive,
        Integer viewCount,
        LocalDateTime updatedAt,
        Integer totalSales
) {
}
