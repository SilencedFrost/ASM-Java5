package com.mapper;

import com.dto.cart.CartCreateRequest;
import com.dto.cart.CartResponse;
import com.dto.cart.CartUpdateRequest;
import com.entity.Cart;
import org.mapstruct.*;

@Mapper(componentModel = "spring")
public interface CartMapper {
    @Mapping(target = "userId", source = "user.userId")
    @Mapping(target = "productId", source = "product.productId")
    CartResponse toDTO(Cart cart);

    Cart toEntity(CartCreateRequest cartCreateRequest);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "user", ignore = true)
    void updateCartFromDTO(CartUpdateRequest cartUpdateRequest, @MappingTarget Cart cart);
}
