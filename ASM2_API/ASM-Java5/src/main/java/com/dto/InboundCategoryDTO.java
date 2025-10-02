package com.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InboundCategoryDTO implements CategoryDTO{
    @NotBlank(message = "Category name cannot be blank")
    private String categoryName;
}
