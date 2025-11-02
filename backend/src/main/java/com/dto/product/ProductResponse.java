package com.dto.product;

import com.dto.product.variation.VariationResponse;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

public record ProductResponse(
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
        BigDecimal rating,
        Integer totalSales,
        List<VariationResponse> variations
) {
}
