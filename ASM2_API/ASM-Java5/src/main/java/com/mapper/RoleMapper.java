package com.mapper;

import com.dto.role.RoleCreateRequest;
import com.dto.role.RoleResponse;
import com.entity.Role;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface RoleMapper {
    RoleResponse toDTO(Role role);

    @Mapping(target = "roleId", ignore = true)
    Role toEntity(RoleCreateRequest request);
}
