package com.example.logindemo.controller;

import com.example.logindemo.dto.PaymentTransactionDTO;
import com.example.logindemo.model.PaymentMode;
import com.example.logindemo.model.User;
import com.example.logindemo.service.PaymentManagementService;
import com.example.logindemo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/payment-management")
@Slf4j
public class PaymentManagementController {

    @Autowired
    private UserService userService;
    
    @Autowired
    private PaymentManagementService paymentManagementService;

    @GetMapping
    public String paymentManagement(Authentication authentication, Model model) {
        log.info("Accessing payment management page");
        
        // Get current user details
        User currentUser = userService.findByUsername(authentication.getName())
            .orElseThrow(() -> new RuntimeException("User not found"));
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("userRole", currentUser.getRole().name());
        
        // Add payment modes for filter dropdown
        model.addAttribute("paymentModes", PaymentMode.values());
        
        return "payment-management/index";
    }
    
    @GetMapping("/search")
    @ResponseBody
    public ResponseEntity<Page<PaymentTransactionDTO>> searchPaymentTransactions(
            @RequestParam(required = false) String searchTerm,
            @RequestParam(required = false, defaultValue = "ALL") String searchType,
            @RequestParam(required = false, defaultValue = "ALL") String paymentMode,
            @RequestParam(required = false, defaultValue = "ALL") String paymentStatus,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        
        log.info("Searching payment transactions: term={}, type={}, mode={}, status={}, page={}, size={}", 
                searchTerm, searchType, paymentMode, paymentStatus, page, size);
        
        Pageable pageable = PageRequest.of(page, size);
        Page<PaymentTransactionDTO> results = paymentManagementService.searchPaymentTransactions(
                searchTerm, searchType, paymentMode, paymentStatus, startDate, endDate, pageable);
        
        return ResponseEntity.ok(results);
    }
    
    @GetMapping("/transaction/{paymentId}")
    @ResponseBody
    public ResponseEntity<PaymentTransactionDTO> getPaymentTransaction(@PathVariable Long paymentId) {
        log.info("Getting payment transaction details for ID: {}", paymentId);
        
        try {
            PaymentTransactionDTO transaction = paymentManagementService.getPaymentTransactionById(paymentId);
            return ResponseEntity.ok(transaction);
        } catch (Exception e) {
            log.error("Error getting payment transaction: {}", e.getMessage());
            return ResponseEntity.notFound().build();
        }
    }
    
    @GetMapping("/examination/{examinationId}/transactions")
    @ResponseBody
    public ResponseEntity<List<PaymentTransactionDTO>> getExaminationTransactions(@PathVariable Long examinationId) {
        log.info("Getting all transactions for examination ID: {}", examinationId);
        
        List<PaymentTransactionDTO> transactions = paymentManagementService.getPaymentTransactionsByExaminationId(examinationId);
        return ResponseEntity.ok(transactions);
    }
    
    @GetMapping("/patient/{patientId}/transactions")
    @ResponseBody
    public ResponseEntity<List<PaymentTransactionDTO>> getPatientTransactions(@PathVariable Long patientId) {
        log.info("=== PAYMENT TRANSACTIONS API DEBUG ===");
        log.info("Getting all transactions for patient ID: {}", patientId);
        
        try {
            List<PaymentTransactionDTO> transactions = paymentManagementService.getPaymentTransactionsByPatientId(patientId);
            
            log.info("Retrieved {} transactions from service", transactions != null ? transactions.size() : 0);
            
            if (transactions != null && !transactions.isEmpty()) {
                log.info("Transaction details:");
                for (int i = 0; i < transactions.size(); i++) {
                    PaymentTransactionDTO transaction = transactions.get(i);
                    log.info("Transaction {}: ID={}, Amount={}, AmountType={}, Refund={}, PaymentDate={}, ProcedureName={}", 
                        i + 1, 
                        transaction.getPaymentId(),
                        transaction.getAmount(),
                        transaction.getAmount() != null ? transaction.getAmount().getClass().getSimpleName() : "null",
                        transaction.isRefund(),
                        transaction.getPaymentDate(),
                        transaction.getProcedureName()
                    );
                }
            } else {
                log.warn("No transactions found for patient ID: {}", patientId);
            }
            
            log.info("Returning response with {} transactions", transactions != null ? transactions.size() : 0);
            log.info("=== END PAYMENT TRANSACTIONS API DEBUG ===");
            
            return ResponseEntity.ok(transactions);
        } catch (Exception e) {
            log.error("Error getting patient transactions for patient ID {}: {}", patientId, e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
    
    @GetMapping("/refund-history/{originalPaymentId}")
    @ResponseBody
    public ResponseEntity<List<PaymentTransactionDTO>> getRefundHistory(@PathVariable Long originalPaymentId) {
        log.info("Getting refund history for payment ID: {}", originalPaymentId);
        
        List<PaymentTransactionDTO> refunds = paymentManagementService.getRefundHistory(originalPaymentId);
        return ResponseEntity.ok(refunds);
    }
}