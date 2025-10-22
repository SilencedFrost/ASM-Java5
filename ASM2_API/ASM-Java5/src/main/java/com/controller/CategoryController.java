package com.controller;

import com.dto.category.CategoryResponse;
import com.dto.category.CategoryWithProductResponse;
import com.dto.user.UserResponse;
import com.service.CategoryService;
import com.service.SessionService;
import com.util.SessionCookieUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/categories")
public class CategoryController {
    private final SessionService sessionService;
    private final SessionCookieUtil sessionCookieUtil;
    private final CategoryService categoryService;

    /**
     * GET /api/categories
     * Fetch all categories
     */
    @GetMapping
    public ResponseEntity<List<CategoryResponse>> getAllCategories(@RequestParam(required = false, defaultValue = "false") boolean viewEmpty, HttpServletRequest request) {
        Optional<UserResponse> user = sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken);
        boolean isAdmin = user.map(u -> u.roleId() == 3).orElse(false);
        log.debug("Fetching all categories");
        return ResponseEntity.ok(isAdmin && viewEmpty? categoryService.findAll() : categoryService.findNotEmpty());
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
    public ResponseEntity<List<CategoryWithProductResponse>> getAllCategoriesWithProducts(HttpServletRequest request) {
        Optional<UserResponse> user = sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken);
        boolean isAdmin = user.map(u -> u.roleId() == 3).orElse(false);
        return ResponseEntity.ok(isAdmin? categoryService.findAllWithProduct() : categoryService.findAllWithActiveProduct());
    }

    /**
     * GET /api/categories/{categoryId}/products
     * Fetch one category with its products
     */
    @GetMapping("/{categoryId}/products")
    public ResponseEntity<CategoryWithProductResponse> getCategoryWithProducts(@PathVariable Integer categoryId, HttpServletRequest request) {
        Optional<UserResponse> user = sessionCookieUtil.getSessionKey(request)
                .flatMap(sessionService::findUserBySessionToken);
        boolean isAdmin = user.map(u -> u.roleId() == 3).orElse(false);
        return (isAdmin? categoryService.findByIdWithProduct(categoryId) : categoryService.findByIdWithActiveProduct(categoryId))
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
