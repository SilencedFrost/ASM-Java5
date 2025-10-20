package com.controller;

import com.dto.product.ProductResponse;
import com.dto.product.ProductSummaryResponse;
import com.dto.seller.SellerResponse;
import com.exception.ProductNotFoundException;
import com.service.ProductService;
import com.service.SessionService;
import com.util.SessionCookieUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {
    private final ProductService productService;
    private final SessionService sessionService;
    private final SessionCookieUtil sessionCookieUtil;


    /**
     * GET /api/products
     * @return all inactive products
     */
    @GetMapping
    public ResponseEntity<List<ProductSummaryResponse>> getAllActiveProducts() {
        return ResponseEntity.ok(productService.findAllActiveSummary());
    }

    /**
     * GET /api/products/{id}
     * @return specific product if active
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getActiveProductById(@PathVariable Long id) {
        return productService.findActiveById(id).map(ResponseEntity::ok).orElseThrow(() -> new ProductNotFoundException("Active product not found"));
    }

    /**
     * GET /api/products/search/{keyword}
     * @return searched result if active
     */
    @GetMapping("/search")
    public ResponseEntity<List<ProductSummaryResponse>> searchActiveProducts(@RequestParam(required = false, defaultValue = "") String keyword) {
        return ResponseEntity.ok(productService.findActiveByNameLike(keyword));
    }

    /**
     * GET /api/products/top/new
     * @return top 5 newest products based on creation date
     */
    @GetMapping("/top/new")
    public ResponseEntity<List<ProductSummaryResponse>> findTop5Latest() {
        return ResponseEntity.ok(productService.findTop5Latest());
    }

    /**
     * GET /api/products/top/selling
     * @return top 5 bestseller products based on total sales
     */
    @GetMapping("/top/selling")
    public ResponseEntity<List<ProductSummaryResponse>> findTop5BestSelling() {
        return ResponseEntity.ok(productService.findTop5BestSelling());
    }

    /**
     * PATCH /api/products/{productId}/toggle-active
     * Toggle the active state of a product
     * @return updated product status
     */
    @PatchMapping("/{productId}/toggle-active")
    public ResponseEntity<ProductResponse> toggleProductActiveState(@PathVariable Long productId, HttpServletRequest request) {
        return sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findSellerBySessionToken)
                .map(SellerResponse::sellerId)
                .filter(sellerId -> productService.isSellerOwnerOf(sellerId, productId))
                .flatMap(sellerId -> productService.toggleActiveState(productId))
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
    }
}