package com.mapper;

import com.dto.cart.CartResponse;
import com.dto.cart.CartUpdateRequest;
import com.entity.Cart;
import com.entity.Product;
import com.entity.Variation;
import org.mapstruct.*;

@Mapper(componentModel = "spring")
public interface CartMapper {
    @Mapping(target = "userId", source = "user.userId")
    @Mapping(target = "productId", source = "product.productId")
    @Mapping(target = "variationId", source = "variation.variationId")
    @Mapping(target = "variation", expression = "java(concatenateVariation(cart.getVariation()))")
    @Mapping(target = "price", source = "variation.price")
    @Mapping(target = "thumbnail", expression = "java(buildThumbnailFilename(cart.getProduct()))")
    @Mapping(target = "productName", source = "product.productName")
    CartResponse toDTO(Cart cart);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "product", ignore = true)
    @Mapping(target = "variation", ignore = true)
    void updateCartFromDTO(CartUpdateRequest cartUpdateRequest, @MappingTarget Cart cart);

    default String concatenateVariation(Variation variation) {
        String size = variation.getProductSize();
        String var = variation.getVariation();
        return size.equals("default") && var.equals("default") ? "default"
                : size.equals("default") ? var
                : var.equals("default") ? size
                : size + ", " + var;
    }

    default String buildThumbnailFilename(Product product) {
        if (product.getThumbnailExtension() == null || product.getProductId() == null) {
            return null;
        }
        return product.getProductId() + "." + product.getThumbnailExtension();
    }
}
