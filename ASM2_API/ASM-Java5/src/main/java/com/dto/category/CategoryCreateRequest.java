package com.dto.category;

public record CategoryCreateRequest(
        String categoryName,
        String description
) {
}
