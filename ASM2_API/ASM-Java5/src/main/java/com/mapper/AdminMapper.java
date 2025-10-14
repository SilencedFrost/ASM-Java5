package com.mapper;


import com.dto.admin.AdminCreateRequest;
import com.dto.admin.AdminResponse;
import com.entity.Admin;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring",
        uses = UserMapper.class,
        unmappedSourcePolicy = ReportingPolicy.IGNORE
)
public interface AdminMapper {

    @Mapping(target = "userResponse", source = "user")
    AdminResponse toDTO(Admin admin);

    Admin toEntity(AdminCreateRequest AdminCreateRequest);
}
