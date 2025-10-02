package com.controller;

import com.constants.CategoryFields;
import com.dto.OutboundCategoryDTO;
import com.service.CategoryService;
import com.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

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
    public ResponseEntity<List<OutboundCategoryDTO>> getAllCategories() {
        log.info("Fetching all categories");
        return ResponseEntity.ok(categoryService.findAll());
    }

    /**
     * GET /api/categories/{id}
     * Fetch category by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<OutboundCategoryDTO> getCategoryById(@PathVariable Integer id) {
        return categoryService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * GET /api/categories/products
     * Fetch all categories with their products
     */
    @GetMapping("/products")
    public ResponseEntity<List<Map<String, Object>>> getAllCategoriesWithProducts() {
        List<OutboundCategoryDTO> categoryList = categoryService.findAll();
        List<Map<String, Object>> dataList = new ArrayList<>();

        for (OutboundCategoryDTO categoryDTO : categoryList) {
            Map<String, Object> dataMap = new HashMap<>();
            dataMap.put(CategoryFields.CATEGORY_ID.getPropertyKey(), categoryDTO.getCategoryId());
            dataMap.put(CategoryFields.CATEGORY_NAME.getPropertyKey(), categoryDTO.getCategoryName());
            dataMap.put(CategoryFields.PRODUCT_COUNT.getPropertyKey(), categoryDTO.getProductCount());
            dataMap.put("products", productService.findByCategory(categoryDTO.getCategoryId()));
            dataList.add(dataMap);
        }

        return ResponseEntity.ok(dataList);
    }

    /**
     * GET /api/categories/{id}/products
     * Fetch one category with its products
     */
    @GetMapping("/{id}/products")
    public ResponseEntity<Map<String, Object>> getCategoryWithProducts(@PathVariable Integer id) {
        return categoryService.findById(id).map(categoryDTO -> {
            Map<String, Object> dataMap = new HashMap<>();
            dataMap.put(CategoryFields.CATEGORY_ID.getPropertyKey(), categoryDTO.getCategoryId());
            dataMap.put(CategoryFields.CATEGORY_NAME.getPropertyKey(), categoryDTO.getCategoryName());
            dataMap.put(CategoryFields.PRODUCT_COUNT.getPropertyKey(), categoryDTO.getProductCount());
            dataMap.put("products", productService.findByCategory(categoryDTO.getCategoryId()));
            return ResponseEntity.ok(dataMap);
        }).orElse(ResponseEntity.notFound().build());
    }
}
