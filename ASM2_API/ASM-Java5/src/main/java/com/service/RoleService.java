package com.service;

import com.dto.*;
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

    public Page<OutboundRoleDTO> findAll(Pageable pageable) {
        return roleRepository.findAll(pageable).map(RoleMapper::toDTO);
    }

    public List<OutboundRoleDTO> findAll() {
        return findAll(PageRequest.of(0, 50)).getContent();
    }

    public Optional<OutboundRoleDTO> findById(Integer roleId) {
        return roleRepository.findById(roleId).map(RoleMapper::toDTO);
    }

    @Transactional
    public OutboundRoleDTO create(InboundRoleDTO roleDTO) {
        Role role = RoleMapper.toEntity(roleDTO);
        Role savedRole = roleRepository.save(role);
        return RoleMapper.toDTO(savedRole);
    }

    @Transactional
    public OutboundRoleDTO update(UpdateRoleDTO roleDTO) {
        Role existingRole = roleRepository.findById(roleDTO.getRoleId())
                .orElseThrow(() -> new RoleNotFoundException("Role not found: " + roleDTO.getRoleId()));

        Optional.ofNullable(roleDTO.getRoleName())
                .filter(s -> !s.isBlank())
                .ifPresent(existingRole::setRoleName);

        return RoleMapper.toDTO(existingRole);
    }

    public void delete(Integer roleId) {
        roleRepository.deleteById(roleId);
    }
}
