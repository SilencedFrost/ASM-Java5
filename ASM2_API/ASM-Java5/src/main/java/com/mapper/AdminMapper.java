package com.mapper;


import com.dto.admin.AdminCreateRequest;
import com.dto.admin.AdminResponse;
import com.entity.Admin;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(
        componentModel = "spring", uses = UserMapper.class,
        unmappedSourcePolicy = ReportingPolicy.IGNORE
)
public interface AdminMapper {

    @Mapping(source = "user", target = "userResponse")
    AdminResponse toDTO(Admin admin);

    @Mapping(source = "userId", target = "user.userId")
    Admin toEntity(AdminCreateRequest AdminCreateRequest);
}
