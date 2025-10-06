package com.controller;

import com.constants.AuthFields;
import com.dto.OutboundUserDTO;
import com.service.UserService;
import com.util.ValidationUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;

    /**
     * POST /api/auth/login
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> inputData, HttpSession session) {
        log.info("Login request received");

        Object user = session.getAttribute("user");
        if (user instanceof OutboundUserDTO outboundUser) {
            return ResponseEntity.ok(outboundUser);
        }

        String usernameOrEmail = inputData.get(AuthFields.USERNAME_OR_EMAIL.getPropertyKey());
        String password = inputData.get(AuthFields.PASSWORD.getPropertyKey());

        if (ValidationUtil.isNullOrBlank(usernameOrEmail) || ValidationUtil.isNullOrBlank(password)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Missing credentials"));
        }

        OutboundUserDTO userDTO = userService.findByUsernameOrEmail(usernameOrEmail).orElse(null);
        if (userDTO != null && userService.validateUser(password, userDTO.getUserId())) {
            userService.updateLoginDate(userDTO.getUserId());
            userDTO.setLastLoginDate(LocalDateTime.now());
            session.setAttribute("user", userDTO);
            return ResponseEntity.ok(userDTO);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Incorrect credentials"));
        }
    }

    /**
     * POST /api/auth/logout
     */
    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpSession session) {
        log.info("Logout request received");
        session.invalidate();
        return ResponseEntity.ok(Map.of("message", "Logged out successfully"));
    }

    /**
     * POST /api/auth/signup
     * (TODO: implement signup logic)
     */
    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody Map<String, String> inputData) {
        log.info("Signup request received");
        // TODO: validate input, create new user, return 201 Created
        return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED)
                .body(Map.of("error", "Signup not yet implemented"));
    }
}
