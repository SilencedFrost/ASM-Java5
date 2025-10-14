package com.mapper;

import com.dto.user.UserCreateRequest;
import com.dto.user.UserResponse;
import com.entity.User;
import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.security.crypto.password.PasswordEncoder;

@Mapper(componentModel = "spring")
public interface UserMapper {
    @Mapping(target = "roleId", source = "role.roleId")
    UserResponse toDTO(User user);

    @Mapping(target = "passwordHash", expression = "java(hashPassword(userCreateRequest.password(), passwordEncoder))")
    User toEntity(UserCreateRequest userCreateRequest, @Context PasswordEncoder passwordEncoder);

    default String hashPassword(String password, @Context PasswordEncoder passwordEncoder) {
        if (password == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        return passwordEncoder.encode(password);
    }
}
