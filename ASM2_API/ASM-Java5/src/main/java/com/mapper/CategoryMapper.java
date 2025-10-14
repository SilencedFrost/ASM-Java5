package com.mapper;

import com.dto.category.CategoryCreateRequest;
import com.dto.category.CategoryResponse;
import com.entity.Category;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring",
        unmappedSourcePolicy = ReportingPolicy.IGNORE
)
public interface CategoryMapper {
    CategoryResponse toDTO(Category category);

    Category toEntity(CategoryCreateRequest categoryCreateRequest);
}
