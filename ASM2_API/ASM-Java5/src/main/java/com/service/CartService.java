package com.service;

import com.dto.cart.CartCreateRequest;
import com.dto.cart.CartResponse;
import com.dto.cart.CartUpdateRequest;
import com.dto.user.UserResponse;
import com.dto.user.UserUpdateRequest;
import com.entity.Cart;
import com.entity.Product;
import com.entity.User;
import com.exception.CartItemNotFoundException;
import com.exception.ProductNotFoundException;
import com.exception.UserNotFoundException;
import com.mapper.CartMapper;
import com.repository.CartRepository;
import com.repository.ProductRepository;
import com.repository.UserRepository;
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

        Product product = productRepository.findById(cartCreateRequest.productId())
                .orElseThrow(() -> new ProductNotFoundException("Product not found with id: " + cartCreateRequest.productId()));

        Optional<Cart> existingCart = cartRepository.findByUserUserIdAndProductProductId(
                userId, cartCreateRequest.productId());

        Cart cart;
        if (existingCart.isPresent()) {
            cart = existingCart.get();
            cart.setQuantity(cart.getQuantity() + cartCreateRequest.quantity());
        } else {
            cart = new Cart();
            cart.assignUser(user);
            cart.assignProduct(product);
            cart.setQuantity(cartCreateRequest.quantity());
        }

        return cartMapper.toDTO(cartRepository.save(cart));
    }

    @Transactional
    public CartResponse update(CartUpdateRequest cartUpdateRequest, Long userId) {
        Cart existingCart = cartRepository.findByUserUserIdAndProductProductId(userId, cartUpdateRequest.productId())
                .orElseThrow(() -> new CartItemNotFoundException("Cart item not found"));
        cartMapper.updateCartFromDTO(cartUpdateRequest, existingCart);

        return cartMapper.toDTO(existingCart);
    }

    @Transactional
    public void removeFromCart(Long userId, Long productId) {
        if (!cartRepository.existsByUserUserIdAndProductProductId(userId, productId)) {
            throw new RuntimeException(
                    "Cart item not found for user " + userId + " and product " + productId);
        }

        cartRepository.deleteByUserUserIdAndProductProductId(userId, productId);
    }

    @Transactional
    public void clearCart(Long userId) {
        if (!userRepository.existsById(userId)) {
            throw new RuntimeException("User not found with id: " + userId);
        }

        List<Cart> carts = cartRepository.findByUserUserId(userId);
        cartRepository.deleteAll(carts);
    }

    @Transactional(readOnly = true)
    public long getCartItemCount(Long userId) {
        return cartRepository.countByUserUserId(userId);
    }
}
