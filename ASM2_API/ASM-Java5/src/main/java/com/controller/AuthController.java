package com.controller;

import com.dto.auth.LoginRequest;
import com.dto.customer.CustomerCreateRequest;
import com.dto.customer.CustomerResponse;
import com.dto.user.UserResponse;
import com.exception.InvalidLoginException;
import com.exception.UserAlreadyExistException;
import com.service.SessionService;
import com.service.UserService;
import com.util.SessionCookieUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;
    private final SessionService sessionService;
    private final SessionCookieUtil sessionCookieUtil;

    /**
     * POST /api/auth/login
     * Validate user login and return the user DTO
     * @return User
     */
    @PostMapping("/login")
    public ResponseEntity<UserResponse> login(@Valid @RequestBody LoginRequest loginRequest, @RequestHeader("User-Agent") String userAgent) {
        UserResponse userResponse = userService.authenticate(loginRequest).orElseThrow(() -> new InvalidLoginException("Incorrect login credentials"));

        String ua = userAgent != null ? userAgent : "Unknown";

        String sessionKey = sessionService.createSession(userResponse.userId(), ua);

        return ResponseEntity.ok().header(HttpHeaders.SET_COOKIE, sessionCookieUtil.createSessionCookie(sessionKey).toString()).body(userResponse);
    }

    /**
     * TODO: implement validation code
     * GET /api/auth/login/session
     * Validate user's session via cookies
     * @return User
     */
    @GetMapping("/login/session")
    public ResponseEntity<UserResponse> loginSession(HttpServletRequest request) {
        Optional<String> sessionToken = sessionCookieUtil.getSessionKey(request);

        return sessionToken.map(s -> sessionService.findUserBySessionToken(s)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()))
                .orElseGet(() -> ResponseEntity.noContent().build());
    }

    /**
     * POST /api/auth/register/customer
     * @return Customer
     */
    @PostMapping("/register/customer")
    public ResponseEntity<CustomerResponse> registerCustomer(@Valid @RequestBody CustomerCreateRequest customerCreateRequest) {
        return userService.createCustomerIfNotExist(customerCreateRequest).map(ResponseEntity::ok).orElseThrow(() -> new UserAlreadyExistException("User email already exists"));
    }

    /**
     * POST /api/auth/logout
     * Get session cookie, invalidate and clear cookie
     */
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(HttpServletRequest httpServletRequest) {
        Optional<String> sessionToken = sessionCookieUtil.getSessionKey(httpServletRequest);

        if (sessionToken.isPresent()) {
            sessionService.invalidate(sessionToken.get());

            return ResponseEntity.ok().header(HttpHeaders.SET_COOKIE, sessionCookieUtil.createDeleteCookie().toString()).build();
        }

        return ResponseEntity.noContent().build();
    }
}
