package com.controller;

import com.dto.OutboundProductDTO;
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
    public ResponseEntity<List<OutboundProductDTO>> getAllProducts() {
        return ResponseEntity.ok(productService.findAll());
    }

    // GET /api/products/{id} -> return product by id
    @GetMapping("/{id}")
    public ResponseEntity<?> getProductById(@PathVariable Long id) {
        OutboundProductDTO productDTO = productService.findById(id).orElse(null);
        if (productDTO == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", "Product not found"));
        }
        return ResponseEntity.ok(productDTO);
    }

    // GET /api/products/search/{keyword} -> search by keyword
    @GetMapping("/search/{keyword}")
    public ResponseEntity<List<OutboundProductDTO>> searchProducts(@PathVariable String keyword) {
        return ResponseEntity.ok(productService.findByNameLike(keyword));
    }
}