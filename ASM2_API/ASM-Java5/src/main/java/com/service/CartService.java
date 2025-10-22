package com.service;

import com.dto.cart.CartCreateRequest;
import com.dto.cart.CartResponse;
import com.dto.cart.CartUpdateRequest;
import com.entity.Cart;
import com.entity.User;
import com.entity.Variation;
import com.exception.CartItemNotFoundException;
import com.exception.CartNotFoundException;
import com.exception.UserNotFoundException;
import com.exception.VariationNotFoundException;
import com.mapper.CartMapper;
import com.repository.CartRepository;
import com.repository.ProductRepository;
import com.repository.UserRepository;
import com.repository.VariationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CartService {

    private final CartRepository cartRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;
    private final CartMapper cartMapper;
    private final VariationRepository variationRepository;

    @Transactional(readOnly = true)
    public List<CartResponse> getCartByUserId(Long userId) {
        return cartRepository.findByUserUserId(userId)
                .stream()
                .map(cartMapper::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public CartResponse addToCart(CartCreateRequest cartCreateRequest, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("User not found with id: " + userId));

        Variation variation = variationRepository.findById(cartCreateRequest.variationId())
                .orElseThrow(() -> new VariationNotFoundException("Variation not found with id: " + cartCreateRequest.variationId()));

        Optional<Cart> existingCart = cartRepository.findByUserUserIdAndVariationVariationId(
                userId, cartCreateRequest.variationId());

        Cart cart;
        if (existingCart.isPresent()) {
            cart = existingCart.get();
            cart.setQuantity(cart.getQuantity() + cartCreateRequest.quantity());
        } else {
            cart = new Cart();
            cart.assignUser(user);
            cart.assignProduct(variation.getProduct());
            cart.assignVariation(variation);
            cart.setQuantity(cartCreateRequest.quantity());
        }

        return cartMapper.toDTO(cartRepository.save(cart));
    }

    @Transactional
    public CartResponse update(CartUpdateRequest cartUpdateRequest, Long userId) {
        Cart existingCart = cartRepository.findByUserUserIdAndVariationVariationId(userId, cartUpdateRequest.variationId())
                .orElseThrow(() -> new CartItemNotFoundException("Cart item not found"));
        cartMapper.updateCartFromDTO(cartUpdateRequest, existingCart);

        return cartMapper.toDTO(existingCart);
    }

    @Transactional
    public Boolean removeFromCart(Long userId, Long variationId) {
        if (!cartRepository.existsByUserUserIdAndVariationVariationId(userId, variationId)) {
            throw new CartItemNotFoundException(
                    "Cart item not found for user " + userId + " and variation " + variationId);
        }
        cartRepository.deleteByUserUserIdAndVariationVariationId(userId, variationId);
        return true;
    }

    @Transactional
    public Void clearCart(Long userId) {
        if (!userRepository.existsById(userId)) {
            throw new CartNotFoundException("Cart of user id: " + userId + " not found");
        }
        List<Cart> carts = cartRepository.findByUserUserId(userId);
        cartRepository.deleteAll(carts);
        return null;
    }

    @Transactional(readOnly = true)
    public long getCartItemCount(Long userId) {
        return cartRepository.countByUserUserId(userId);
    }
}
