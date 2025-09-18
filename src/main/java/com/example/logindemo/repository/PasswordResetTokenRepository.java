package com.example.logindemo.repository;

import com.example.logindemo.model.PasswordResetToken;
import com.example.logindemo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {
    
    /**
     * Find a password reset token by token string
     */
    Optional<PasswordResetToken> findByToken(String token);
    
    /**
     * Find all tokens for a specific user
     */
    Optional<PasswordResetToken> findByUser(User user);
    
    /**
     * Find valid (non-expired, non-used) token by token string
     */
    @Query("SELECT t FROM PasswordResetToken t WHERE t.token = :token AND t.expiryDate > :now AND t.used = false")
    Optional<PasswordResetToken> findValidToken(@Param("token") String token, @Param("now") LocalDateTime now);
    
    /**
     * Delete all expired tokens
     */
    @Modifying
    @Query("DELETE FROM PasswordResetToken t WHERE t.expiryDate < :now")
    void deleteExpiredTokens(@Param("now") LocalDateTime now);
    
    /**
     * Delete all tokens for a specific user
     */
    @Modifying
    @Query("DELETE FROM PasswordResetToken t WHERE t.user = :user")
    void deleteByUser(@Param("user") User user);
    
    /**
     * Mark token as used
     */
    @Modifying
    @Query("UPDATE PasswordResetToken t SET t.used = true WHERE t.token = :token")
    void markTokenAsUsed(@Param("token") String token);
}