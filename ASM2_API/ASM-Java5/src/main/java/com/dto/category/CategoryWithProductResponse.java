package com.dto.category;

import com.dto.product.ProductResponse;

import java.util.List;

public record CategoryWithProductResponse(
        Integer categoryId,
        String categoryName,
        String description,
        Boolean isActive,
        List<ProductResponse> productResponses
) {
}
