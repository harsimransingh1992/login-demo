package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "password_reset_tokens")
public class PasswordResetToken {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String token;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(nullable = false)
    private LocalDateTime expiryDate;
    
    @Column(nullable = false)
    private LocalDateTime createdDate;
    
    @Column(nullable = false)
    private Boolean used = false;
    
    public PasswordResetToken() {
        this.createdDate = LocalDateTime.now();
        this.expiryDate = LocalDateTime.now().plusMinutes(30); // 30 minutes expiry
    }
    
    public PasswordResetToken(String token, User user) {
        this();
        this.token = token;
        this.user = user;
    }
    
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(this.expiryDate);
    }
    
    public boolean isUsed() {
        return this.used;
    }
    
    public boolean isValid() {
        return !isExpired() && !isUsed();
    }
}