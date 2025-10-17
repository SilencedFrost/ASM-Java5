package com.dto.product;

import com.dto.product.variation.ProductVariationUpdateRequest;

import java.util.List;

public record ProductUpdateRequest(
        Long productId,
        String productName,
        Integer categoryId,
        String thumbnail,
        String description,
        Boolean isActive,
        List<ProductVariationUpdateRequest> productVariations
) {
}
