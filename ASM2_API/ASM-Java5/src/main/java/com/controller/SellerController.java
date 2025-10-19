package com.controller;

import com.dto.product.ProductSummaryResponse;
import com.dto.seller.SellerResponse;
import com.dto.user.UserResponse;
import com.service.ProductService;
import com.service.SellerService;
import com.service.SessionService;
import com.util.SessionCookieUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/sellers")
@RequiredArgsConstructor
public class SellerController {
    private final ProductService productService;
    private final SessionService sessionService;
    private final SellerService sellerService;
    private final SessionCookieUtil sessionCookieUtil;

    /**
     * @return the authenticated seller's full product catalogue
     */
    @GetMapping("/products")
    public ResponseEntity<List<ProductSummaryResponse>> getSellerProductsAuthorized(HttpServletRequest request) {
        return sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken)
                .flatMap(user -> sellerService.findByUserId(user.userId())
                        .map(SellerResponse::sellerId)
                        .map(productService::findAllSummaryBySeller))
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
    }

    /**
     * @return the seller's active product catalogue
     */
    @GetMapping("/{sellerId:[0-9]+}/products")
    public ResponseEntity<List<ProductSummaryResponse>> getSellerProducts(@PathVariable Long sellerId) {
        return ResponseEntity.ok(productService.findAllActiveSummaryBySeller(sellerId));
    }
}