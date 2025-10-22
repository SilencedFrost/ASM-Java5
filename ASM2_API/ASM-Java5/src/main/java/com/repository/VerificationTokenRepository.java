package com.repository;

import com.entity.VerificationToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface VerificationTokenRepository extends JpaRepository<VerificationToken, Long> {

    Optional<VerificationToken> findByTokenHash(String tokenHash);

    Optional<VerificationToken> findByUserUserId(Long userId);

    Optional<VerificationToken> findByUserUserIdAndTokenHash(Long userId, String tokenHash);
}
