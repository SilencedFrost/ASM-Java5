package com.mapper;

import com.dto.role.RoleCreateRequest;
import com.dto.role.RoleResponse;
import com.entity.Role;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring",
        unmappedSourcePolicy = ReportingPolicy.IGNORE
)

public interface RoleMapper {
    RoleResponse toDTO(Role role);

    Role toEntity(RoleCreateRequest roleCreateRequest);
}