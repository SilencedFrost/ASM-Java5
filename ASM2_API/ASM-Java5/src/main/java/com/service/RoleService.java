package com.service;

import com.dto.role.*;
import com.entity.Role;
import com.exception.RoleNotFoundException;
import com.mapper.RoleMapper;
import com.repository.RoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoleService {
    public final RoleRepository roleRepository;
    public final RoleMapper roleMapper;

    public Page<RoleResponse> findAll(Pageable pageable) {
        return roleRepository.findAll(pageable).map(roleMapper::toDTO);
    }

    public List<RoleResponse> findAll() {
        return findAll(PageRequest.of(0, 50)).getContent();
    }

    public Optional<RoleResponse> findById(Integer roleId) {
        return roleRepository.findById(roleId).map(roleMapper::toDTO);
    }

    @Transactional
    public RoleResponse create(RoleCreateRequest roleCreateRequest) {
        Role role = roleMapper.toEntity(roleCreateRequest);
        Role savedRole = roleRepository.save(role);
        return roleMapper.toDTO(savedRole);
    }

    @Transactional
    public RoleResponse update(RoleUpdateRequest roleUpdateRequest) {
        Role existingRole = roleRepository.findById(roleUpdateRequest.roleId())
                .orElseThrow(() -> new RoleNotFoundException("Role not found: " + roleUpdateRequest.roleId()));

        Optional.ofNullable(roleUpdateRequest.roleName())
                .filter(s -> !s.isBlank())
                .ifPresent(existingRole::setRoleName);

        return roleMapper.toDTO(existingRole);
    }

    public void delete(Integer roleId) {
        roleRepository.deleteById(roleId);
    }
}
