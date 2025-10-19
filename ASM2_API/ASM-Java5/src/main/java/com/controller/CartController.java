package com.controller;

import com.dto.cart.CartCreateRequest;
import com.dto.cart.CartResponse;
import com.service.CartService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @GetMapping("/{userId}")
    public ResponseEntity<List<CartResponse>> getCart(@PathVariable Long userId) {
        List<CartResponse> cart = cartService.getCartByUserId(userId);
        return ResponseEntity.ok(cart);
    }

    @PostMapping
    public ResponseEntity<CartResponse> addToCart(@Valid @RequestBody CartCreateRequest request) {
        CartResponse cartResponse = cartService.addToCart(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(cartResponse);
    }

    @PutMapping("/{userId}/product/{productId}")
    public ResponseEntity<CartResponse> updateCartQuantity(
            @PathVariable Long userId,
            @PathVariable Long productId,
            @RequestBody Map<String, Integer> request) {

        Integer quantity = request.get("quantity");
        CartResponse cartResponse = cartService.updateCartQuantity(userId, productId, quantity);
        return ResponseEntity.ok(cartResponse);
    }

    @DeleteMapping("/{userId}/product/{productId}")
    public ResponseEntity<Void> removeFromCart(
            @PathVariable Long userId,
            @PathVariable Long productId) {

        cartService.removeFromCart(userId, productId);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<Void> clearCart(@PathVariable Long userId) {
        cartService.clearCart(userId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{userId}/count")
    public ResponseEntity<Map<String, Long>> getCartItemCount(@PathVariable Long userId) {
        long count = cartService.getCartItemCount(userId);
        return ResponseEntity.ok(Map.of("count", count));
    }
}