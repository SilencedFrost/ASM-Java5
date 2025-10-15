package com.mapper;

import com.dto.user.UserCreateRequest;
import com.dto.user.UserResponse;
import com.entity.User;
import com.service.HashService;
import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {
    @Mapping(target = "roleId", source = "role.roleId")
    UserResponse toDTO(User user);

    @Mapping(target = "passwordHash", expression = "java(hashPassword(userCreateRequest.password(), hashService))")
    User toEntity(UserCreateRequest userCreateRequest, @Context HashService hashService);

    default String hashPassword(String password, @Context HashService hashService) {
        if (password == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        return hashService.hashPassword(password);
    }
}
