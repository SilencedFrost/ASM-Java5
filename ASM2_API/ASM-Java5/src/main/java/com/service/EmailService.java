package com.service;

import com.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender mailSender;
    private final HttpServletRequest request;

    @Value("${spring.mail.username}")
    private String from;

    public void sendOtpEmail(String toEmail, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(from);
        message.setTo(toEmail);
        message.setSubject("Mã xác nhận đặt lại mật khẩu");
        message.setText("""
                Xin chào,
                
                Mã OTP của bạn là: %s
                
                Mã này chỉ có hiệu lực trong thời gian phiên làm việc hiện tại.
                
                Trân trọng,
                Hệ thống hỗ trợ tài khoản EasyEat.
                """.formatted(otp));
        mailSender.send(message);
    }

    public void sendVerificationEmail(User user, String token) {
        String baseUrl = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());
        String verificationUrl = baseUrl + "/api/auth/verify/" + token;

        SimpleMailMessage email = new SimpleMailMessage();
        email.setFrom(from);
        email.setTo(user.getEmail());
        email.setSubject("Kích hoạt tài khoản EasyEat của bạn");
        email.setText("Xin chào " + user.getUsername() + ",\n\n"
                + "Cảm ơn bạn đã đăng ký. Vui lòng nhấp vào liên kết bên dưới để kích hoạt tài khoản của bạn:\n"
                + verificationUrl + "\n\n"
                + "Liên kết này sẽ hết hạn sau 30 phút.\n\n"
                + "Trân trọng,\n"
                + "Đội ngũ EasyEat");

        mailSender.send(email);
        log.info("Verification email sent to: {}", user.getEmail());
    }

}
