package com.dto.product;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record ProductSummaryResponse(
        Long productId,
        String productName,
        Long sellerId,
        String sellerName,
        Integer categoryId,
        OffsetDateTime creationDate,
        OffsetDateTime updateDate,
        String thumbnail,
        String description,
        Boolean isActive,
        Integer viewCount,
        Integer totalSales,
        BigDecimal price
) {
}
