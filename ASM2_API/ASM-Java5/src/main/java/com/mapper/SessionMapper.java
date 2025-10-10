package com.mapper;

import com.dto.session.SessionCreateRequest;
import com.dto.session.SessionResponse;
import com.entity.Session;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface SessionMapper {
    SessionResponse toDTO(Session session);

    @Mapping(target = "sessionId", ignore = true)
    Session toEntity(SessionCreateRequest sessionRequest);
}
