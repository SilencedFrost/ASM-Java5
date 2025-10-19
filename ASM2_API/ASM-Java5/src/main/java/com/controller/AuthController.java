package com.controller;

import com.dto.auth.LoginRequest;
import com.dto.auth.RegisterRequest;
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
import org.springframework.http.ResponseCookie;
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

        if (loginRequest.rememberMe()) {
            String ua = userAgent != null ? userAgent : "Unknown";
            String sessionKey = sessionService.createSession(userResponse.userId(), ua);
            ResponseCookie sessionCookie = sessionCookieUtil.createSessionCookie(sessionKey);

            return ResponseEntity.ok()
                    .header(HttpHeaders.SET_COOKIE, sessionCookie.toString())
                    .body(userResponse);
        }

        return ResponseEntity.ok().body(userResponse);
    }

    /**
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
    public ResponseEntity<UserResponse> registerCustomer(@Valid @RequestBody RegisterRequest registerRequest, @RequestHeader("User-Agent") String userAgent) {
        UserResponse userResponse = userService.registerIfNotExist(registerRequest).orElseThrow(() -> new UserAlreadyExistException("account with this email already exists"));

        if (registerRequest.rememberMe()) {
            String ua = userAgent != null ? userAgent : "Unknown";
            String sessionKey = sessionService.createSession(userResponse.userId(), ua);
            ResponseCookie sessionCookie = sessionCookieUtil.createSessionCookie(sessionKey);

            return ResponseEntity.ok()
                    .header(HttpHeaders.SET_COOKIE, sessionCookie.toString())
                    .body(userResponse);
        }

        return ResponseEntity.ok().body(userResponse);
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
