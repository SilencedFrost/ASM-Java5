package com.mapper;

import com.dto.category.CategoryCreateRequest;
import com.dto.category.CategoryResponse;
import com.dto.category.CategoryWithProductResponse;
import com.entity.Category;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = ProductMapper.class
)
public interface CategoryMapper {
    CategoryResponse toDTO(Category category);

    @Mapping(target = "productResponses", source = "products")
    CategoryWithProductResponse toDTOWithProduct(Category category);

    @Mapping(target = "isActive", ignore = true)
    @Mapping(target = "products", ignore = true)
    Category toEntity(CategoryCreateRequest categoryCreateRequest);
}
