package com.dto.product;

import com.dto.product.variation.VariationCreateRequest;

import java.util.List;

public record ProductCreateRequest(
        String productName,
        Long sellerId,
        Integer categoryId,
        String thumbnail,
        String description,
        Boolean isActive,
        List<VariationCreateRequest> productVariations
) {
}
