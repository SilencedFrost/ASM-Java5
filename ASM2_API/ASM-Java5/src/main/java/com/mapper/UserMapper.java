package com.mapper;

import com.dto.user.UserCreateRequest;
import com.dto.user.UserResponse;
import com.entity.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserResponse toDTO(User user);

    @Mapping(target = "userId", ignore = true)
    User toEntity(UserCreateRequest userRequest);
}
