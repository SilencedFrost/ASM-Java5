package com.mapper;

import com.dto.auth.VerificationTokenRequest;
import com.entity.VerificationToken;
import org.apache.commons.codec.digest.DigestUtils;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface VerificationTokenMapper {

    @Mapping(target = "tokenHash", expression = "java(hashToken(verificationTokenRequest.token()))")
    @Mapping(target = "user", ignore = true)
    VerificationToken toEntity(VerificationTokenRequest verificationTokenRequest);

    default String hashToken(String token) {
        if (token == null) {
            throw new IllegalArgumentException("sessionToken cannot be null");
        }
        return DigestUtils.sha256Hex(token);
    }
}
