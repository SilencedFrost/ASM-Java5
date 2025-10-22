package com.controller;

import com.dto.product.ProductSummaryResponse;
import com.dto.seller.SellerResponse;
import com.service.ProductService;
import com.service.SessionService;
import com.util.SessionCookieUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/sellers")
@RequiredArgsConstructor
public class SellerController {
    private final ProductService productService;
    private final SessionService sessionService;
    private final SessionCookieUtil sessionCookieUtil;

    /**
     * GET /api/seller/products
     * @return the authenticated seller's full product catalogue
     */
    @GetMapping("/products")
    public ResponseEntity<List<ProductSummaryResponse>> getSellerProductsAuthorized(HttpServletRequest request) {
        return sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findSellerBySessionToken)
                .map(SellerResponse::sellerId)
                .map(productService::findAllSummaryBySeller)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
    }

    /**
     * GET /api/seller/{sellerId}/products
     * @return the seller's active product catalogue
     */
    @GetMapping("/{sellerId:[0-9]+}/products")
    public ResponseEntity<List<ProductSummaryResponse>> getSellerProducts(@PathVariable Long sellerId) {
        return ResponseEntity.ok(productService.findAllActiveSummaryBySeller(sellerId));
    }
}