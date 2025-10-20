package com.repository;

import com.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository <Product, Long> {

    List<Product> findByIsActiveTrue();

    List<Product> findBySellerSellerIdAndIsActiveTrue(Long sellerId);

    List<Product> findBySellerSellerId(Long sellerId);

    List<Product> findTop5ByOrderByCreationDateDesc();

    List<Product> findTop5ByOrderByTotalSalesDesc();

    List<Product> findByProductNameContainsIgnoreCase(String keyword);

    List<Product> findByProductNameContainsIgnoreCaseAndIsActiveTrue(String keyword);

    Optional<Product> findByProductIdAndIsActiveTrue(Long productId);

    boolean existsBySellerSellerIdAndProductId(Long sellerId, Long productId);
}
