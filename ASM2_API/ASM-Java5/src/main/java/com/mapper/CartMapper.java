package com.mapper;

import com.dto.cart.CartCreateRequest;
import com.dto.cart.CartResponse;
import com.entity.Cart;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring",
        unmappedSourcePolicy = ReportingPolicy.IGNORE
)
public interface CartMapper {
    @Mapping(target = "userId", source = "user.userId")
    @Mapping(target = "productId", source = "product.productId")
    CartResponse toDTO(Cart cart);

    Cart toEntity(CartCreateRequest cartCreateRequest);
}
