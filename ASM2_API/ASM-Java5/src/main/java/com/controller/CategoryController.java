package com.controller;

import com.dto.category.CategoryResponse;
import com.dto.category.CategoryWithProductResponse;
import com.service.CategoryService;
import com.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/categories")
public class CategoryController {
    private final CategoryService categoryService;
    private final ProductService productService;

    /**
     * GET /api/categories
     * Fetch all categories
     */
    @GetMapping
    public ResponseEntity<List<CategoryResponse>> getAllCategories() {
        log.debug("Fetching all categories");
        return ResponseEntity.ok(categoryService.findAll());
    }

    /**
     * GET /api/categories/{id}
     * Fetch category by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<CategoryResponse> getCategoryById(@PathVariable Integer id) {
        log.debug("Fetching all categories with Id of: {}", id);
        return categoryService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * GET /api/categories/products
     * Fetch all categories with their products
     */
    @GetMapping("/products")
    public ResponseEntity<List<CategoryWithProductResponse>> getAllCategoriesWithProducts() {
        log.debug("Fetching all categories along with products");
        return ResponseEntity.ok(categoryService.findAllWithProduct());
    }

    /**
     * GET /api/categories/{id}/products
     * Fetch one category with its products
     */
    @GetMapping("/{id}/products")
    public ResponseEntity<CategoryWithProductResponse> getCategoryWithProducts(@PathVariable Integer id) {
        log.debug("Fetching category Id: {} with all it's products", id);
        return categoryService.findByIdWithProduct(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
