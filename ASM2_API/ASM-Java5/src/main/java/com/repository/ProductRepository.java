package com.repository;

import com.entity.Product;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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

    List<Product> findByProductNameContainsIgnoreCaseAndIsActiveTrue(String keyword, Sort sort);

    Optional<Product> findByProductIdAndIsActiveTrue(Long productId);

    boolean existsBySellerSellerIdAndProductId(Long sellerId, Long productId);

    @Query("SELECT p FROM Product p " +
            "LEFT JOIN p.variations pv " +
            "WHERE p.isActive = true AND LOWER(p.productName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "GROUP BY p.productId " +
            "ORDER BY MIN(pv.price) ASC")
    List<Product> findActiveByNameLikeOrderByMinPriceAsc(@Param("keyword") String keyword);

    @Query("SELECT p FROM Product p " +
            "LEFT JOIN p.variations pv " +
            "WHERE p.isActive = true AND LOWER(p.productName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "GROUP BY p.productId " +
            "ORDER BY MIN(pv.price) DESC")
    List<Product> findActiveByNameLikeOrderByMinPriceDesc(@Param("keyword") String keyword);
}
