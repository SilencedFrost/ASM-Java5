package com.mapper;


import com.dto.admin.AdminCreateRequest;
import com.dto.admin.AdminResponse;
import com.entity.Admin;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = UserMapper.class
)
public interface AdminMapper {
    AdminResponse toDTO(Admin admin);

    @Mapping(target = "user", ignore = true)
    Admin toEntity(AdminCreateRequest AdminCreateRequest);
}
