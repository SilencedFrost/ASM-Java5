package com.repository;

import com.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository <Cart, Long>, JpaSpecificationExecutor<Cart> {

    List<Cart> findByUser_UserId(Long userId);

    Optional<Cart> findByUser_UserIdAndProduct_ProductId(Long userId, Long productId);

    boolean existsByUser_UserIdAndProduct_ProductId(Long userId, Long productId);

    void deleteByUser_UserIdAndProduct_ProductId(Long userId, Long productId);

    long countByUser_UserId(Long userId);
}
