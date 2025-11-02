package com.mapper;

import com.dto.product.variation.VariationCreateRequest;
import com.dto.product.variation.VariationResponse;
import com.entity.Variation;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface VariationMapper {

    @Mapping(target = "productId", source = "product.productId")
    @Mapping(target = "image", expression = "java(buildImageFilename(variation))")
    VariationResponse toDTO(Variation variation);

    @Mapping(target = "imageExtension", ignore = true)
    @Mapping(target = "carts", ignore = true)
    Variation toEntity(VariationCreateRequest variationCreateRequest);

    default String buildImageFilename(Variation variation) {
        if (variation.getImageExtension() == null || variation.getProduct() == null || variation.getVariationId() == null) {
            return null;
        }
        return variation.getProduct().getProductId() + "-" + variation.getVariationId() + "." + variation.getImageExtension();
    }
}
