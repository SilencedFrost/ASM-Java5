package com.repository;

import com.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository <Product, Long> {
    List<Product> findByCategoryCategoryId(Integer categoryId);

    List<Product> findByIsActiveTrue();

    List<Product> findBySellerSellerIdAndIsActiveTrue(Long sellerId);

    List<Product> findBySellerSellerId(Long sellerId);

    List<Product> findByProductNameContainsIgnoreCase(String productName);
}
