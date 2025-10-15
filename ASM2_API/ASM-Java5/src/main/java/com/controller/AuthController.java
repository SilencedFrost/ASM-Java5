package com.controller;

import com.dto.auth.LoginRequest;
import com.dto.user.UserCreateRequest;
import com.dto.user.UserResponse;
import com.entity.User;
import com.exception.InvalidLoginException;
import com.exception.UserAlreadyExistException;
import com.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;

    /**
     * POST /api/auth/login
     * Validate user login and return the user DTO
     */
    @PostMapping("/login")
    public ResponseEntity<UserResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        return userService.authenticate(loginRequest).map(ResponseEntity::ok).orElseThrow(() -> new InvalidLoginException("Incorrect login credentials"));
    }

    @PostMapping("/register")
    public ResponseEntity<UserResponse> register(@Valid @RequestBody UserCreateRequest userCreateRequest) {
        return userService.createIfNotExist(userCreateRequest).map(ResponseEntity::ok).orElseThrow(() -> new UserAlreadyExistException("Email already exists"));
    }
}
