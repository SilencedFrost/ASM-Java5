package com.controller;

import com.dto.auth.LoginRequest;
import com.dto.customer.CustomerCreateRequest;
import com.dto.customer.CustomerResponse;
import com.dto.user.UserResponse;
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

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;

    /**
     * POST /api/auth/login
     * Validate user login and return the user DTO
     * @param loginRequest
     * @return User
     */
    @PostMapping("/login")
    public ResponseEntity<UserResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        return userService.authenticate(loginRequest).map(ResponseEntity::ok).orElseThrow(() -> new InvalidLoginException("Incorrect login credentials"));
    }

    /**
     * POST/api/auth/register/customer
     * @param customerCreateRequest
     * @return Customer
     */
    @PostMapping("/register/customer")
    public ResponseEntity<CustomerResponse> registerCustomer(@Valid @RequestBody CustomerCreateRequest customerCreateRequest) {
        return userService.createCustomerIfNotExist(customerCreateRequest).map(ResponseEntity::ok).orElseThrow(() -> new UserAlreadyExistException("User email already exists"));
    }
}
