package com.controller;

import com.dto.product.ProductResponse;
import com.dto.product.ProductSummaryResponse;
import com.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {
    private final ProductService productService;

    // GET /api/products -> return all products
    @GetMapping
    public ResponseEntity<List<ProductSummaryResponse>> getAllProducts() {
        return ResponseEntity.ok(productService.findAllActiveSummary());
    }

    // GET /api/products/{id} -> return product by id
    @GetMapping("/{id}")
    public ResponseEntity<?> getProductById(@PathVariable Long id) {
        ProductResponse productDTO = productService.findById(id).orElse(null);
        if (productDTO == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", "Product not found"));
        }
        return ResponseEntity.ok(productDTO);
    }

    // GET /api/products/search/{keyword} -> search by keyword
    @GetMapping("/search")
    public ResponseEntity<List<ProductSummaryResponse>> searchProducts(@RequestParam(required = false, defaultValue = "") String keyword) {
        return ResponseEntity.ok(productService.findByNameLike(keyword));
    }

    @GetMapping("/top/new")
    public ResponseEntity<List<ProductSummaryResponse>> findTop5Latest() {
        return ResponseEntity.ok(productService.findTop5Latest());
    }

    @GetMapping("/top/selling")
    public ResponseEntity<List<ProductSummaryResponse>> findTop5BestSelling() {
        return ResponseEntity.ok(productService.findTop5BestSelling());
    }
}