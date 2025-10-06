package com.mapper;

import com.dto.InboundCategoryDTO;
import com.dto.OutboundCategoryDTO;
import com.dto.CategoryDTO;
import com.entity.Category;

import java.util.ArrayList;
import java.util.List;

public class CategoryMapper {

    public static OutboundCategoryDTO toDTO(Category category) {
        if (category == null) {
            return null;
        }
        return new OutboundCategoryDTO(
                category.getCategoryId(),
                category.getCategoryName(),
                category.getProducts().size()
        );
    }

    public static Category toEntity(InboundCategoryDTO categoryDTO) {
        if (categoryDTO == null) {
            return null;
        }

        return new Category(
                categoryDTO.getCategoryName()
        );
    }
}
