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

    /**
     * DELETE /api/cart/product/{variationId}
     * @param variationId the variation of the product that is to be deleted from cart
     * @return void
     */
    @DeleteMapping("/product/{variationId}")
    public ResponseEntity<Boolean> removeFromCart(@PathVariable Long variationId, HttpServletRequest request) {
        return sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken)
                .map(u -> cartService.removeFromCart(u.userId(), variationId))
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
    }

    /**
     * DELETE /api/cart
     * @return void
     */
    @DeleteMapping
    public ResponseEntity<Void> clearCart(HttpServletRequest request) {
        return sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken)
                .map(UserResponse::userId)
                .map(cartService::clearCart)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
    }

    /**
     * GET /api/cart/count
     * @return number of unique item variations in user's cart
     */
    @GetMapping("/count")
    public ResponseEntity<Map<String, Long>> getCartItemCount(HttpServletRequest request) {
        return sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken)
                .map(UserResponse::userId)
                .map(cartService::getCartItemCount)
                .map(count -> Map.of("count", count))
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
    }
}