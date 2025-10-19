package com.service;

import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender mailSender;

    public void sendOtpEmail(String toEmail, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Mã xác nhận đặt lại mật khẩu");
        message.setText("""
                Xin chào,
                
                Mã OTP của bạn là: %s
                
                Mã này chỉ có hiệu lực trong thời gian phiên làm việc hiện tại.
                
                Trân trọng,
                Hệ thống hỗ trợ tài khoản.
                """.formatted(otp));
        mailSender.send(message);
    }

}
