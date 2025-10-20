package com.controller;

import com.dto.user.ProfileUpdateRequest;
import com.dto.user.UserResponse;
import com.service.SessionService;
import com.service.UserService;
import com.util.SessionCookieUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/users")
public class AccountController {

    private final UserService userService;
    private final SessionService sessionService;
    private final SessionCookieUtil sessionCookieUtil;

    /**
     * GET /api/users/profile
     * API này được frontend gọi khi tải trang "Thông tin cá nhân".
     * Nó đọc cookie, tìm session, và trả về UserResponse (JSON)
     * để đổ dữ liệu lên form.
     */

    @GetMapping("/profile")
    public ResponseEntity<UserResponse> getProfile(HttpServletRequest request) {
        Optional<String> sessionToken = sessionCookieUtil.getSessionKey(request);

        if (sessionToken.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        return sessionService.findUserBySessionToken(sessionToken.get())
                .map(ResponseEntity::ok)
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.UNAUTHORIZED));
    }

    /**
     * PUT /api/users/profile
     * API này được frontend gọi khi người dùng nhấn nút "Lưu thay đổi".
     * Nó nhận DTO chứa thông tin mới (ProfileUpdateRequest) từ body.
     * Nó xác thực user qua session cookie, sau đó cập nhật thông tin vào database
     * @return Trả về UserResponse (JSON) chứa thông tin đã được cập nhật
     */

   @PutMapping("/profile")
    public ResponseEntity<UserResponse> updateProfile(HttpServletRequest request,
                                                      @Valid @RequestBody ProfileUpdateRequest profileUpdateRequest) {
        Optional<String> sessionToken = sessionCookieUtil.getSessionKey(request);

       if (sessionToken.isEmpty()) {
           return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
       }

       Long userId = sessionService.findUserBySessionToken(sessionToken.get()).get().userId();

       UserResponse updatedUser = userService.updateProfile(userId, profileUpdateRequest);

       return ResponseEntity.ok(updatedUser);
   }
}
