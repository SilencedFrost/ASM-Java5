package com.mapper;

import com.dto.product.variation.ProductVariationCreateRequest;
import com.dto.product.variation.ProductVariationResponse;
import com.entity.ProductVariation;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ProductVariationMapper {

    @Mapping(target = "productId", source = "product.productId")
    @Mapping(target = "image", expression = "java(buildImageFilename(productVariation))")
    ProductVariationResponse toDTO(ProductVariation productVariation);

    @Mapping(target = "imageExtension", ignore = true)
    ProductVariation toEntity(ProductVariationCreateRequest productVariationCreateRequest);

    default String buildImageFilename(ProductVariation variation) {
        if (variation.getImageExtension() == null || variation.getProduct() == null || variation.getVariationId() == null) {
            return null;
        }
        return variation.getProduct().getProductId() + "-" + variation.getVariationId() + "." + variation.getImageExtension();
    }
}
