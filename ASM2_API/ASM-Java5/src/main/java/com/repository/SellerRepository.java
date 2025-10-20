package com.repository;

import com.entity.Seller;
import com.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SellerRepository extends JpaRepository <Seller, Long> {
    Optional<Seller> findByUserUserId(Long userId);
}