package com.dto.product;

import java.math.BigDecimal;
<<<<<<< HEAD
=======
import java.time.LocalDateTime;
>>>>>>> 7b71dfe (feat: add mapper and repo cart category product #61)
import java.time.OffsetDateTime;

public record ProductResponse(
        Long productId,
        String productName,
        Long parentId,
        Long sellerId,
        Integer categoryId,
        OffsetDateTime creationDate,
        Integer stockCount,
        String thumbnailExtension,
        String productSize,
        String variation,
        String description,
        BigDecimal price,
        Boolean isActive,
        Integer viewCount,
        OffsetDateTime updateDate,
        Integer totalSales
) {
}
