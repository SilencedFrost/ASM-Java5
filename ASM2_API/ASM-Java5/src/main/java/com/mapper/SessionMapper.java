package com.mapper;

import com.dto.session.SessionCreateRequest;
import com.dto.session.SessionResponse;
import com.entity.Session;
import org.apache.commons.codec.digest.DigestUtils;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring",
        unmappedSourcePolicy = ReportingPolicy.IGNORE
)
public interface SessionMapper {

    @Mapping(target = "userId", source = "user.userId")
    SessionResponse toDTO(Session session);

    @Mapping(target = "sessionHash", expression = "java(hashToken(sessionCreateRequest.sessionToken()))")
    Session toEntity(SessionCreateRequest sessionCreateRequest);

    default String hashToken(String token) {
        if (token == null) {
            throw new IllegalArgumentException("sessionToken cannot be null");
        }
        return DigestUtils.sha256Hex(token);
    }
}
