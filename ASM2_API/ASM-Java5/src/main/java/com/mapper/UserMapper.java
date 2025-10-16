package com.mapper;

import com.dto.user.UserCreateRequest;
import com.dto.user.UserResponse;
import com.entity.User;
import com.service.HashService;
import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

@Mapper(componentModel = "spring")
public interface UserMapper {
    @Mapping(target = "roleId", source = "role.roleId")
    UserResponse toDTO(User user);

    @Mapping(target = "passwordHash", source = "password", qualifiedByName = "hashPassword")
    @Mapping(target = "isActive", ignore = true)
    @Mapping(target = "sessions", ignore = true)
    User toEntity(UserCreateRequest userCreateRequest, @Context HashService hashService);

    @Named("hashPassword")
    default String hashPassword(String password, @Context HashService hashService) {
        if (password == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        return hashService.hashPassword(password);
    }
}
