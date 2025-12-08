package com.repository;

import com.entity.Product;
import org.jspecify.annotations.NullMarked;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository <Product, Long> {

    @NullMarked
    @EntityGraph(value = "product-with-detail")
    List<Product> findAll();

    @EntityGraph(value = "product-with-detail")
    List<Product> findBySellerSellerId(Long sellerId);

    // N=5, does not benefit from EntityGraph
    // @EntityGraph(value = "product-with-detail")
    List<Product> findTop5ByOrderByCreationDateDesc();

    // N=5, does not benefit from EntityGraph
    // @EntityGraph(value = "product-with-detail")
    List<Product> findTop5ByOrderByTotalSalesDesc();

    @EntityGraph(value = "product-with-detail")
    List<Product> findByProductNameContainsIgnoreCase(String keyword, Sort sort);

    boolean existsBySellerSellerIdAndProductId(Long sellerId, Long productId);

    @EntityGraph(value = "product-with-detail")
    @Query("SELECT p FROM Product p " +
            "LEFT JOIN p.variations pv " +
            "WHERE p.isActive = true AND LOWER(p.productName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "GROUP BY p.productId " +
            "ORDER BY MIN(pv.price) ASC")
    List<Product> findActiveByNameLikeOrderByMinPriceAsc(@Param("keyword") String keyword);

    @EntityGraph(value = "product-with-detail")
    @Query("SELECT p FROM Product p " +
            "LEFT JOIN p.variations pv " +
            "WHERE p.isActive = true AND LOWER(p.productName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "GROUP BY p.productId " +
            "ORDER BY MIN(pv.price) DESC")
    List<Product> findActiveByNameLikeOrderByMinPriceDesc(@Param("keyword") String keyword);
}
