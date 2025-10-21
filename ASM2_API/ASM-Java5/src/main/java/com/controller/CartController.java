package com.controller;

import com.dto.cart.CartCreateRequest;
import com.dto.cart.CartResponse;
import com.dto.cart.CartUpdateRequest;
import com.dto.user.UserResponse;
import com.service.CartService;
import com.service.SessionService;
import com.util.SessionCookieUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {
    private final SessionService sessionService;
    private final SessionCookieUtil sessionCookieUtil;
    private final CartService cartService;

    /**
     * GET /api/cart
     * @return authenticated user's list of items
     */
    @GetMapping()
    public ResponseEntity<List<CartResponse>> getCart(HttpServletRequest request) {
        return sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken)
                .map(UserResponse::userId)
                .map(cartService::getCartByUserId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
    }

    /**
     * POST /api/cart
     * @param cartCreateRequest cart create request
     * @return created cart item if request succeed
     */
    @PostMapping
    public ResponseEntity<CartResponse> addToCart(@Valid @RequestBody CartCreateRequest cartCreateRequest, HttpServletRequest request) {
        return sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken)
                .map(u -> cartService.addToCart(cartCreateRequest, u.userId()))
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
    }

    /**
     * PUT /api/cart
     * @param cartUpdateRequest cart update request
     * @return update cart if authenticated
     */
    @PutMapping
    public ResponseEntity<CartResponse> updateCartQuantity(@Valid @RequestBody CartUpdateRequest cartUpdateRequest, HttpServletRequest request) {
        return sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken)
                .map(u -> cartService.update(cartUpdateRequest, u.userId()))
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
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