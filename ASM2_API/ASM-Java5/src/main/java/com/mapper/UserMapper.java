package com.mapper;

import com.dto.InboundUserDTO;
import com.dto.OutboundUserDTO;
import com.dto.UserDTO;
import com.entity.Role;
import com.entity.User;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class UserMapper {

    public static OutboundUserDTO toDTO(User user) {
        if (user == null) {
            return null;
        }
        return new OutboundUserDTO(
                user.getUserId(),
                user.getUsername(),
                user.getEmail(),
                user.getCreationDate(),
                user.getRole() != null ? user.getRole().getRoleName() : "null",
                user.isActive(),
                user.getLastLoginDate()
        );
    }

    public static User toEntity(InboundUserDTO userDTO, Role role) {
        if (userDTO == null) {
            return null;
        }

        return new User(
                userDTO.getUsername(),
                userDTO.getEmail(),
                userDTO.getPasswordHash(),
                role,
                userDTO.isActive()
        );
    }
}
