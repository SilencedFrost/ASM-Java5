package com.service;

import com.dto.cart.CartCreateRequest;
import com.dto.cart.CartResponse;
import com.entity.Cart;
import com.entity.Product;
import com.entity.User;
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
        if (!userRepository.existsById(userId)) {
            throw new RuntimeException("User not found with id: " + userId);
        }

        List<Cart> carts = cartRepository.findByUserUserId(userId);
        return carts.stream()
                .map(cartMapper::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public CartResponse addToCart(CartCreateRequest request) {
        User user = userRepository.findById(request.userId())
                .orElseThrow(() -> new RuntimeException("User not found with id: " + request.userId()));

        Product product = productRepository.findById(request.productId())
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + request.productId()));

        Optional<Cart> existingCart = cartRepository.findByUserUserIdAndProductProductId(
                request.userId(), request.productId());

        Cart cart;
        if (existingCart.isPresent()) {
            cart = existingCart.get();
            cart.setQuantity(cart.getQuantity() + request.quantity());
        } else {
            cart = new Cart();
            cart.assignUser(user);
            cart.assignProduct(product);
            cart.setQuantity(request.quantity());
        }

        Cart savedCart = cartRepository.save(cart);
        return cartMapper.toDTO(savedCart);
    }

    @Transactional
    public CartResponse updateCartQuantity(Long userId, Long productId, Integer quantity) {
        if (quantity == null || quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than 0");
        }

        Cart cart = cartRepository.findByUserUserIdAndProductProductId(userId, productId)
                .orElseThrow(() -> new RuntimeException(
                        "Cart item not found for user " + userId + " and product " + productId));

        cart.setQuantity(quantity);
        Cart updatedCart = cartRepository.save(cart);

        return cartMapper.toDTO(updatedCart);
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
