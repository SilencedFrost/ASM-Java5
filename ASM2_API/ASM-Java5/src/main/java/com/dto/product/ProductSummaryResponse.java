package com.dto.product;

import com.dto.product.variation.ProductVariationResponse;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

public record ProductSummaryResponse(
        Long productId,
        String productName,
        Long sellerId,
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
