package com.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UpdateCategoryDTO extends InboundCategoryDTO{
    private Integer categoryId;

    public UpdateCategoryDTO(Integer categoryId, String categoryName) {
        super(categoryName);
        this.categoryId = categoryId;
    }
}
