package com.mapper;

import com.dto.InboundRoleDTO;
import com.dto.OutboundRoleDTO;
import com.dto.RoleDTO;
import com.entity.Role;

import java.util.ArrayList;
import java.util.List;

public class RoleMapper {

    public static RoleDTO toDTO(Role role) {
        if (role == null) {
            return null;
        }
        return new OutboundRoleDTO(
                role.getRoleId(),
                role.getRoleName()
        );
    }

    public static Role toEntity(InboundRoleDTO roleDTO) {
        if (roleDTO == null) {
            return null;
        }

        return new Role(
                roleDTO.getRoleName()
        );
    }

    public static List<RoleDTO> toDTOList(List<Role> entityList) {
        List<RoleDTO> dtoList = new ArrayList<>();
        for (Role role : entityList) {
            dtoList.add(RoleMapper.toDTO(role));
        }
        return dtoList;
    }
}
