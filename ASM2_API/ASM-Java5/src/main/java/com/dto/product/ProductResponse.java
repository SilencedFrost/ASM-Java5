package com.dto.product;

import com.dto.product.variation.ProductVariationResponse;

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
        Integer viewCount,
        Integer totalSales,
        List<ProductVariationResponse> productVariations
) {
}
