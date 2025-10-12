package com.dto.category;

public record CategoryUpdateRequest(
        Integer categoryId,
        String categoryName,
        String description,
        Boolean isActive
) {
}
