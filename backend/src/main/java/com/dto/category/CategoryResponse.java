package com.dto.category;

public record CategoryResponse(
        Integer categoryId,
        String categoryName,
        String description,
        Boolean isActive
) {
}
