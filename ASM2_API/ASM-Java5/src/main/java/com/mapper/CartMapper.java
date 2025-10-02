package com.mapper;

import com.dto.CartDTO;
import com.entity.Cart;
import com.entity.CartPK;
import com.entity.Product;
import com.entity.User;

import java.util.ArrayList;
import java.util.List;

public class CartMapper {

    public static CartDTO toDTO(Cart cart) {
        if (cart == null) {
            return null;
        }
        return new CartDTO(
                cart.getId().getUser().getUserId(),
                cart.getId().getProduct().getProductId(),
                cart.getQuantity()
        );
    }

    public static Cart toEntity(CartDTO cartDTO, User user, Product product) {
        if (cartDTO == null) {
            return null;
        }
        Cart cart = new Cart();
        cart.setId(new CartPK(user, product));
        cart.setQuantity(cartDTO.getQuantity());
        return cart;
    }

    public static List<CartDTO> toDTOList(List<Cart> entityList) {
        List<CartDTO> dtoList = new ArrayList<>();
        for (Cart cart : entityList) {
            dtoList.add(CartMapper.toDTO(cart));
        }
        return dtoList;
    }
}
