package com.service;

import com.dto.*;
import com.entity.Role;
import com.entity.User;
import com.exception.RoleNotFoundException;
import com.exception.UserNotFoundException;
import com.mapper.UserMapper;
import com.repository.RoleRepository;
import com.repository.UserRepository;
import com.security.PasswordHasher;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public Page<OutboundUserDTO> findAll(Pageable pageable) {
        return userRepository.findAll(pageable).map(UserMapper::toDTO);
    }

    public List<OutboundUserDTO> findAll() {
        return findAll(PageRequest.of(0, 50)).getContent();
    }

    public Optional<OutboundUserDTO> findById(Long userId) {
        return userRepository.findById(userId).map(UserMapper::toDTO);
    }

    public Optional<OutboundUserDTO> findByUsernameOrEmail(String usernameOrEmail) {
        return userRepository.findByUsernameIgnoreCaseOrEmailIgnoreCase(usernameOrEmail, usernameOrEmail)
                .map(UserMapper::toDTO);
    }

    public boolean validateUser(String password, Long userId) {
        return userRepository.findById(userId)
                .map(user -> PasswordHasher.verify(password, user.getPasswordHash()))
                .orElse(false);
    }

    @Transactional
    public OutboundUserDTO create(InboundUserDTO userDTO) {
        Role role = roleRepository.findByRoleName(userDTO.getRoleName()).orElseThrow(() -> new RoleNotFoundException("Role not found: " + userDTO.getRoleName()));

        User user = UserMapper.toEntity(userDTO, role);
        User savedUser = userRepository.save(user);

        return UserMapper.toDTO(savedUser);
    }

    @Transactional
    public boolean updateLoginDate(Long userId) {
        return userRepository.findById(userId)
                .map(user -> {
                    user.setLastLoginDate(LocalDateTime.now());
                    return true;
                })
                .orElse(false);
    }

    @Transactional
    public OutboundUserDTO update(UpdateUserDTO userDTO) {
        User existingUser = userRepository.findById(userDTO.getUserId())
                .orElseThrow(() -> new UserNotFoundException("User not found: " + userDTO.getUserId()));

        if (userDTO.getUsername() != null && !userDTO.getUsername().isBlank()) {
            existingUser.setUsername(userDTO.getUsername());
        }
        if (userDTO.getPasswordHash() != null && !userDTO.getPasswordHash().isBlank()) {
            existingUser.setPasswordHash(userDTO.getPasswordHash());
        }
        if (userDTO.getEmail() != null && !userDTO.getEmail().isBlank()) {
            existingUser.setEmail(userDTO.getEmail());
        }
        if (userDTO.getRoleName() != null && !userDTO.getRoleName().isBlank()) {
            Role role = roleRepository.findByRoleName(userDTO.getRoleName())
                    .orElse(null);
            existingUser.setRole(role);
        }

        return UserMapper.toDTO(existingUser);
    }

    @Transactional
    public void delete(Long userId) {
        userRepository.deleteById(userId);
    }
}
