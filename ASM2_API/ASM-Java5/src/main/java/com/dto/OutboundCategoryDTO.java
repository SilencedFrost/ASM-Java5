package com.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OutboundCategoryDTO implements CategoryDTO{
    private Integer categoryId;
    private String categoryName;
    private Integer productCount;
}
