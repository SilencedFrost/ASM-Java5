package com.dto.product;

import com.dto.product.variation.VariationUpdateRequest;

import java.util.List;

public record ProductUpdateRequest(
        Long productId,
        String productName,
        Integer categoryId,
        String thumbnail,
        String description,
        Boolean isActive,
        List<VariationUpdateRequest> productVariations
) {
}
