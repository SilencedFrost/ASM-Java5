package com.service;

import com.dto.seller.SellerResponse;
import com.mapper.SellerMapper;
import com.repository.SellerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class SellerService {
    private final SellerRepository sellerRepository;
    private final SellerMapper sellerMapper;

    public Optional<SellerResponse> findByUserId(Long userId) {
        return sellerRepository.findByUserUserId(userId).map(sellerMapper::toDTO);
    }
}
