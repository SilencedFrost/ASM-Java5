package com.service;

import com.dto.auth.LoginRequest;
import com.dto.auth.RegisterRequest;
import com.dto.user.UserCreateRequest;
import com.dto.user.UserResponse;
import com.dto.user.UserUpdateRequest;
import com.entity.Role;
import com.entity.User;
import com.exception.RoleNotFoundException;
import com.exception.UserNotFoundException;
import com.mapper.UserMapper;
import com.repository.CustomerRepository;
import com.repository.RoleRepository;
import com.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {
    private final CustomerRepository customerRepository;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserMapper userMapper;
    private final HashService hashService;

    public Page<UserResponse> findAll(Pageable pageable) {
        return userRepository.findAll(pageable).map(userMapper::toDTO);
    }

    public List<UserResponse> findAll() {
        return findAll(PageRequest.of(0, 50)).getContent();
    }

    public Optional<UserResponse> findById(Long userId) {
        return userRepository.findById(userId).map(userMapper::toDTO);
    }

    public Optional<UserResponse> findByEmail(String email) {
        return userRepository.findByEmailIgnoreCase(email).map(userMapper::toDTO);
    }

    public Optional<UserResponse> authenticate(LoginRequest loginRequest) {
        return userRepository.findByEmailIgnoreCase(loginRequest.email())
                .filter(user -> hashService.verifyPassword(loginRequest.password(), user.getPasswordHash())).map(userMapper::toDTO);
    }

    @Transactional
    public UserResponse create(UserCreateRequest userCreateRequest) {
        Role role = roleRepository.findById(userCreateRequest.roleId()).orElseThrow(() -> new RoleNotFoundException("Role not found: " + userCreateRequest.roleId()));

        User user = userMapper.toEntity(userCreateRequest, hashService);
        user.assignRole(role);
        User savedUser = userRepository.save(user);

        return userMapper.toDTO(savedUser);
    }

    @Transactional
    public Optional<UserResponse> registerIfNotExist(RegisterRequest registerRequest) {

        if (userRepository.existsByEmail(registerRequest.email())) {
            log.info("User with email {} already exists. Skipping creation.", registerRequest.email());
            return Optional.empty();
        }

        User user = userMapper.toEntity(registerRequest, hashService);
        Role customerRole = roleRepository.findByRoleName("customer")
                .orElseThrow(() -> new RoleNotFoundException("'customer' role not found"));
        user.assignRole(customerRole);
        user = userRepository.save(user);

        return Optional.of(userMapper.toDTO(user));
    }

    @Transactional
    public UserResponse update(UserUpdateRequest userUpdateRequest) {
        User existingUser = userRepository.findById(userUpdateRequest.userId())
                .orElseThrow(() -> new UserNotFoundException("User not found: " + userUpdateRequest.userId()));

        if (userUpdateRequest.username() != null && !userUpdateRequest.username().isBlank()) {
            existingUser.setUsername(userUpdateRequest.username());
        }
        if (userUpdateRequest.password() != null && !userUpdateRequest.password().isBlank()) {
            existingUser.setPasswordHash(hashService.hashPassword(userUpdateRequest.password()));
        }
        if (userUpdateRequest.email() != null && !userUpdateRequest.email().isBlank()) {
            existingUser.setEmail(userUpdateRequest.email());
        }
        if (userUpdateRequest.roleId() != null) {
            Role role = roleRepository.findById(userUpdateRequest.roleId())
                    .orElse(null);
            existingUser.assignRole(role);
        }

        return userMapper.toDTO(existingUser);
    }

    @Transactional
    public void delete(Long userId) {
        userRepository.deleteById(userId);
    }
}
