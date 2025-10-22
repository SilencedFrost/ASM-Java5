package com.controller;

import com.dto.product.ProductResponse;
import com.dto.product.ProductSummaryResponse;
import com.dto.seller.SellerResponse;
import com.dto.user.UserResponse;
import com.exception.ProductNotFoundException;
import com.exception.SellerNotFoundException;
import com.exception.UserNotFoundException;
import com.service.ProductService;
import com.service.SellerService;
import com.service.SessionService;
import com.util.SessionCookieUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {
    private final ProductService productService;
    private final SessionService sessionService;
    private final SessionCookieUtil sessionCookieUtil;
    private final SellerService sellerService;


    /**
     * GET /api/products
     * @return all product for admin, and only inactive products for other roles
     */
    @GetMapping
    public ResponseEntity<List<ProductSummaryResponse>> getAllProducts(HttpServletRequest request) {
        Optional<UserResponse> user = sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken);
        boolean isAdmin = user.map(u -> u.roleId() == 3).orElse(false);
        var products = isAdmin
                ? productService.findAllSummary()
                : productService.findAllActiveSummary();
        return ResponseEntity.ok(products);
    }

    /**
     * GET /api/products/{productId}
     * @return specific product for admin, and only active products unless seller owns it, and only active product for other roles
     */
    @GetMapping("/{productId}")
    public ResponseEntity<ProductResponse> getProductById(@PathVariable Long productId, HttpServletRequest request) {
        Optional<UserResponse> user = sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken);
        boolean allowed;
        allowed = user.map(userResponse -> switch (userResponse.roleId()) {
            case 3 -> true;
            case 2 -> {
                Long sellerId = sellerService.findByUserId(userResponse.userId())
                        .map(SellerResponse::sellerId)
                        .orElseThrow(() -> new SellerNotFoundException("Seller not found"));
                yield productService.isSellerOwnerOf(sellerId, productId);
            }
            default -> false;
        }).orElse(false);
        var product = allowed
                ? productService.findById(productId)
                : productService.findActiveById(productId);

        return product
                .map(ResponseEntity::ok)
                .orElseThrow(() -> new ProductNotFoundException("Product not found"));
    }

    /**
     * GET /api/products/search
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
        UserResponse user = sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken)
                .orElseThrow(() -> new UserNotFoundException("User not found"));
        boolean allowed = switch (user.roleId()) {
            case 3 -> true;
            case 2 -> {
                Long sellerId = sellerService.findByUserId(user.userId())
                        .map(SellerResponse::sellerId)
                        .orElseThrow(() -> new SellerNotFoundException("Seller not found"));
                yield productService.isSellerOwnerOf(sellerId, productId);
            }
            default -> false;
        };

        if (!allowed)
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();

        return productService.toggleActiveState(productId)
                .map(ResponseEntity::ok)
                .orElseThrow(() -> new ProductNotFoundException("Product not found"));
    }
}