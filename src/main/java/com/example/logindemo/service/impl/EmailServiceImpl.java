package com.example.logindemo.service.impl;

import com.example.logindemo.service.EmailService;
import com.example.logindemo.service.dto.EmailAttachment;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;

import javax.mail.internet.MimeMessage;
import java.util.List;

@Service
@Slf4j
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSender emailSender;

    @Value("${spring.mail.username:noreply@peridesk.com}")
    private String fromEmail;

    @Override
    public void sendDailyReport(String recipient, String subject, String content) {
        log.info("Starting email send process to recipient: {}", recipient);
        log.info("Email subject: {}", subject);
        log.info("Email content length: {} characters", content != null ? content.length() : 0);
        log.info("From email configured as: {}", fromEmail);
        
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(recipient);
            message.setSubject(subject);
            message.setText(content);
            
            log.info("Email message prepared. Attempting to send via JavaMailSender...");
            emailSender.send(message);
            log.info("Daily report email sent successfully to: {}", recipient);
            
        } catch (Exception e) {
            log.error("Failed to send daily report email to: {}. Error type: {}", recipient, e.getClass().getSimpleName());
            log.error("Error message: {}", e.getMessage());
            log.error("Full stack trace:", e);
            throw new RuntimeException("Failed to send email", e);
        }
    }

    @Override
    public void sendSimpleMessage(String to, String subject, String text) {
        log.info("Starting simple email send process to recipient: {}", to);
        log.info("Email subject: {}", subject);
        log.info("Email text length: {} characters", text != null ? text.length() : 0);
        log.info("From email configured as: {}", fromEmail);
        
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            
            log.info("Simple email message prepared. Attempting to send via JavaMailSender...");
            emailSender.send(message);
            log.info("Email sent successfully to: {}", to);
            
        } catch (Exception e) {
            log.error("Failed to send email to: {}. Error type: {}", to, e.getClass().getSimpleName());
            log.error("Error message: {}", e.getMessage());
            log.error("Full stack trace:", e);
            throw new RuntimeException("Failed to send email", e);
        }
    }

    @Override
    public void sendMessageWithAttachments(String[] recipients, String subject, String text,
                                           List<EmailAttachment> attachments) {
        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setFrom(fromEmail);
            helper.setTo(recipients);
            helper.setSubject(subject);
            helper.setText(text, false);

            if (attachments != null) {
                for (EmailAttachment att : attachments) {
                    if (att != null && att.getContent() != null && att.getFilename() != null) {
                        helper.addAttachment(att.getFilename(), new ByteArrayResource(att.getContent()),
                                att.getContentType() != null ? att.getContentType() : "application/octet-stream");
                    }
                }
            }

            emailSender.send(message);
            log.info("Email with attachments sent successfully to: {}", (Object) recipients);
        } catch (Exception e) {
            log.error("Failed to send email with attachments to recipients", e);
            throw new RuntimeException("Failed to send email with attachments", e);
        }
    }
}