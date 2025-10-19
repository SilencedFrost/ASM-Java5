package com.controller;

import com.dto.product.ProductResponse;
import com.dto.product.ProductSummaryResponse;
import com.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;


@Slf4j
@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    // GET /api/products -> return all products
    @GetMapping
    public ResponseEntity<List<ProductResponse>> getAllProducts() {
        return ResponseEntity.ok(productService.findAll());
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
    @GetMapping("/search/{keyword}")
    public ResponseEntity<List<ProductSummaryResponse>> searchProducts(@PathVariable String keyword) {
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