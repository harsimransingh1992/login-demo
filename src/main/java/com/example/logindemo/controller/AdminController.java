package com.example.logindemo.controller;

import com.example.logindemo.dto.DoctorDetailDTO;
import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.CityTier;
import com.example.logindemo.model.DentalDepartment;
import com.example.logindemo.model.DoctorDetail;
import com.example.logindemo.model.ProcedurePrice;
import com.example.logindemo.model.User;
import com.example.logindemo.model.CheckInRecord;
import com.example.logindemo.model.Patient;
import com.example.logindemo.repository.DoctorDetailRepository;
import com.example.logindemo.repository.ProcedurePriceRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.repository.CheckInRecordRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.service.DoctorDetailService;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/admin")
@Slf4j
public class AdminController {

    @Resource(name = "userRepository")
    private UserRepository userRepository;

    @Resource(name = "doctorDetailRepository")
    private DoctorDetailRepository doctorDetailRepository;
    
    @Resource(name = "doctorDetailService")
    private DoctorDetailService doctorDetailService;
    
    @Resource(name = "procedurePriceRepository")
    private ProcedurePriceRepository procedurePriceRepository;
    
    @Resource(name = "modelMapper")
    private ModelMapper modelMapper;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Resource(name = "patientRepository")
    private PatientRepository patientRepository;
    
    @Resource(name = "checkInRecordRepository")
    private CheckInRecordRepository checkInRecordRepository;
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping
    public String adminDashboard() {
        return "admin/dashboard";
    }
    
    // User Management
    @GetMapping("/users")
    public String listUsers(Model model) {
        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "admin/users";
    }
    
    @GetMapping("/users/create")
    public String showCreateUserForm(Model model) {
        model.addAttribute("user", new User());
        return "admin/create-user";
    }
    
    @PostMapping("/users/create")
    public String createUser(@ModelAttribute User user, Model model) {
        // Check if username already exists
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            model.addAttribute("error", "Username already exists");
            return "admin/create-user";
        }
        
        // Encode password
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setOnboardDoctors(new ArrayList<>());
        
        // Save user
        userRepository.save(user);
        return "redirect:/admin/users?success";
    }
    
    @GetMapping("/users/{id}/edit")
    public String showEditUserForm(@PathVariable Long id, Model model) {
        Optional<User> user = userRepository.findById(id);
        if (!user.isPresent()) {
            return "redirect:/admin/users?error=User not found";
        }
        
        model.addAttribute("user", user.get());
        return "admin/edit-user";
    }
    
    @PostMapping("/users/{id}/edit")
    public String updateUser(@PathVariable Long id, @ModelAttribute User userForm, 
                          @RequestParam(value = "newPassword", required = false) String newPassword,
                          Model model) {
        Optional<User> userOpt = userRepository.findById(id);
        if (!userOpt.isPresent()) {
            return "redirect:/admin/users?error=User not found";
        }
        
        User user = userOpt.get();
        
        // Check if username is being changed and if it's already taken
        if (!user.getUsername().equals(userForm.getUsername())) {
            if (userRepository.findByUsername(userForm.getUsername()).isPresent()) {
                model.addAttribute("error", "Username already exists");
                model.addAttribute("user", user);
                return "admin/edit-user";
            }
            user.setUsername(userForm.getUsername());
        }
        
        // Update city tier
        user.setCityTier(userForm.getCityTier());
        
        // Update password if provided
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            user.setPassword(passwordEncoder.encode(newPassword));
        }
        
        userRepository.save(user);
        return "redirect:/admin/users?success=updated";
    }
    
    @PostMapping("/users/update-tier")
    @PreAuthorize("hasRole('ADMIN')")
    public String updateUserCityTier(@RequestParam("userId") Long userId, 
                                    @RequestParam(value = "cityTier", required = false) String cityTier,
                                    Model model) {
        log.info("Updating city tier for user ID: {} to {}", userId, cityTier);
        
        // Find the user
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            log.error("User not found with ID: {}", userId);
            return "redirect:/admin/users?error=User not found";
        }
        
        User user = userOpt.get();
        
        // Update city tier
        if (cityTier != null && !cityTier.isEmpty()) {
            try {
                CityTier tier = CityTier.valueOf("TIER" + cityTier);
                user.setCityTier(tier);
                log.info("Set city tier to: {}", tier);
            } catch (IllegalArgumentException e) {
                log.error("Invalid city tier: {}", cityTier, e);
                return "redirect:/admin/users?error=Invalid city tier";
            }
        } else {
            // If cityTier is empty, set to null
            user.setCityTier(null);
            log.info("Cleared city tier for user");
        }
        
        // Save user
        userRepository.save(user);
        log.info("User city tier updated successfully");
        
        return "redirect:/admin/users?tierUpdated=true";
    }
    
    // Doctor Management
    @GetMapping("/doctors")
    public String listDoctors(Model model) {
        List<DoctorDetail> doctors = doctorDetailRepository.findAll();
        List<User> clinics = userRepository.findAll();
        
        model.addAttribute("doctors", doctors);
        model.addAttribute("clinics", clinics);
        return "admin/doctors";
    }
    
    @GetMapping("/doctors/create")
    public String showCreateDoctorForm(Model model) {
        model.addAttribute("doctor", new DoctorDetailDTO());
        model.addAttribute("clinics", userRepository.findAll());
        return "admin/create-doctor";
    }
    
    @PostMapping("/doctors/create")
    public String createDoctor(@ModelAttribute DoctorDetailDTO doctorDTO, @RequestParam Long clinicId, Model model) {
        try {
            Optional<User> clinic = userRepository.findById(clinicId);
            if (!clinic.isPresent()) {
                model.addAttribute("error", "Clinic not found");
                model.addAttribute("clinics", userRepository.findAll());
                return "admin/create-doctor";
            }
            
            DoctorDetail doctor = new DoctorDetail();
            doctor.setDoctorName(doctorDTO.getDoctorName());
            doctor.setOnboardClinic(clinic.get());
            
            doctorDetailRepository.save(doctor);
            return "redirect:/admin/doctors?success";
        } catch (Exception e) {
            model.addAttribute("error", "Error creating doctor: " + e.getMessage());
            model.addAttribute("clinics", userRepository.findAll());
            return "admin/create-doctor";
        }
    }
    
    @PostMapping("/doctors/{id}/delete")
    @ResponseBody
    public ResponseEntity<?> deleteDoctor(@PathVariable Long id) {
        try {
            Optional<DoctorDetail> doctor = doctorDetailRepository.findById(id);
            if (!doctor.isPresent()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Doctor not found"));
            }
            
            doctorDetailRepository.delete(doctor.get());
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
    
    @GetMapping("/doctors/{id}/edit")
    public String showEditDoctorForm(@PathVariable Long id, Model model) {
        Optional<DoctorDetail> doctor = doctorDetailRepository.findById(id);
        if (!doctor.isPresent()) {
            return "redirect:/admin/doctors?error=not-found";
        }
        
        model.addAttribute("doctor", doctor.get());
        model.addAttribute("clinics", userRepository.findAll());
        return "admin/edit-doctor";
    }
    
    @PostMapping("/doctors/{id}/edit")
    public String updateDoctor(@PathVariable Long id, @ModelAttribute DoctorDetailDTO doctorDTO, 
                              @RequestParam Long clinicId, Model model) {
        try {
            Optional<DoctorDetail> existingDoctor = doctorDetailRepository.findById(id);
            if (!existingDoctor.isPresent()) {
                return "redirect:/admin/doctors?error=not-found";
            }
            
            Optional<User> clinic = userRepository.findById(clinicId);
            if (!clinic.isPresent()) {
                model.addAttribute("error", "Clinic not found");
                model.addAttribute("doctor", existingDoctor.get());
                model.addAttribute("clinics", userRepository.findAll());
                return "admin/edit-doctor";
            }
            
            DoctorDetail doctor = existingDoctor.get();
            doctor.setDoctorName(doctorDTO.getDoctorName());
            doctor.setOnboardClinic(clinic.get());
            
            doctorDetailRepository.save(doctor);
            return "redirect:/admin/doctors?success=updated";
        } catch (Exception e) {
            model.addAttribute("error", "Error updating doctor: " + e.getMessage());
            model.addAttribute("clinics", userRepository.findAll());
            return "admin/edit-doctor";
        }
    }
    
    // Procedure Price Management
    @GetMapping("/prices")
    public String listProcedurePrices(Model model, @RequestParam(required = false) String query) {
        List<ProcedurePrice> prices;
        
        if (query != null && !query.trim().isEmpty()) {
            // Search functionality
            prices = procedurePriceRepository.findByProcedureNameContainingIgnoreCase(query);
            model.addAttribute("searchQuery", query);
        } else {
            prices = procedurePriceRepository.findAll();
        }
        
        model.addAttribute("procedures", prices);
        return "admin/procedure-prices";
    }
    
    @GetMapping("/prices/create")
    public String showCreateProcedurePriceForm(Model model) {
        model.addAttribute("procedure", new ProcedurePriceDTO());
        model.addAttribute("cityTiers", CityTier.values());
        model.addAttribute("dentalDepartments", DentalDepartment.values());
        return "admin/create-procedure";
    }
    
    @PostMapping("/prices/create")
    public String createProcedurePrice(@ModelAttribute ProcedurePriceDTO procedureDTO, Model model) {
        try {
            // Validate all required fields
            if (procedureDTO.getProcedureName() == null || procedureDTO.getProcedureName().trim().isEmpty()) {
                model.addAttribute("error", "Procedure name is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                return "admin/create-procedure";
            }
            
            if (procedureDTO.getCityTier() == null) {
                model.addAttribute("error", "City tier is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                return "admin/create-procedure";
            }
            
            if (procedureDTO.getDentalDepartment() == null) {
                model.addAttribute("error", "Department is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                return "admin/create-procedure";
            }
            
            if (procedureDTO.getPrice() == null || procedureDTO.getPrice() <= 0) {
                model.addAttribute("error", "Valid price is required (must be greater than zero)");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                return "admin/create-procedure";
            }
            
            ProcedurePrice procedurePrice = new ProcedurePrice();
            procedurePrice.setProcedureName(procedureDTO.getProcedureName());
            procedurePrice.setCityTier(procedureDTO.getCityTier());
            procedurePrice.setPrice(procedureDTO.getPrice());
            procedurePrice.setDentalDepartment(procedureDTO.getDentalDepartment());
            
            procedurePriceRepository.save(procedurePrice);
            return "redirect:/admin/prices?success";
        } catch (Exception e) {
            model.addAttribute("error", "Error creating procedure price: " + e.getMessage());
            model.addAttribute("cityTiers", CityTier.values());
            model.addAttribute("dentalDepartments", DentalDepartment.values());
            return "admin/create-procedure";
        }
    }
    
    @GetMapping("/prices/{id}/edit")
    public String showEditProcedurePriceForm(@PathVariable Long id, Model model) {
        Optional<ProcedurePrice> procedure = procedurePriceRepository.findById(id);
        if (!procedure.isPresent()) {
            return "redirect:/admin/prices?error=not-found";
        }
        
        model.addAttribute("procedure", procedure.get());
        model.addAttribute("cityTiers", CityTier.values());
        model.addAttribute("dentalDepartments", DentalDepartment.values());
        return "admin/edit-procedure";
    }
    
    @PostMapping("/prices/{id}/edit")
    public String updateProcedurePrice(@PathVariable Long id, @ModelAttribute ProcedurePriceDTO procedureDTO, Model model) {
        try {
            Optional<ProcedurePrice> existingProcedure = procedurePriceRepository.findById(id);
            if (!existingProcedure.isPresent()) {
                return "redirect:/admin/prices?error=not-found";
            }
            
            // Validate all required fields
            if (procedureDTO.getProcedureName() == null || procedureDTO.getProcedureName().trim().isEmpty()) {
                model.addAttribute("error", "Procedure name is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                model.addAttribute("procedure", procedureDTO);
                return "admin/edit-procedure";
            }
            
            if (procedureDTO.getCityTier() == null) {
                model.addAttribute("error", "City tier is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                model.addAttribute("procedure", procedureDTO);
                return "admin/edit-procedure";
            }
            
            if (procedureDTO.getDentalDepartment() == null) {
                model.addAttribute("error", "Department is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                model.addAttribute("procedure", procedureDTO);
                return "admin/edit-procedure";
            }
            
            if (procedureDTO.getPrice() == null || procedureDTO.getPrice() <= 0) {
                model.addAttribute("error", "Valid price is required (must be greater than zero)");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                model.addAttribute("procedure", procedureDTO);
                return "admin/edit-procedure";
            }
            
            ProcedurePrice procedurePrice = existingProcedure.get();
            procedurePrice.setProcedureName(procedureDTO.getProcedureName());
            procedurePrice.setCityTier(procedureDTO.getCityTier());
            procedurePrice.setPrice(procedureDTO.getPrice());
            procedurePrice.setDentalDepartment(procedureDTO.getDentalDepartment());
            
            procedurePriceRepository.save(procedurePrice);
            return "redirect:/admin/prices?success=updated";
        } catch (Exception e) {
            model.addAttribute("error", "Error updating procedure price: " + e.getMessage());
            model.addAttribute("cityTiers", CityTier.values());
            model.addAttribute("dentalDepartments", DentalDepartment.values());
            model.addAttribute("procedure", procedureDTO);
            return "admin/edit-procedure";
        }
    }
    
    @PostMapping("/prices/{id}/delete")
    @ResponseBody
    public ResponseEntity<?> deleteProcedurePrice(@PathVariable Long id) {
        try {
            Optional<ProcedurePrice> procedure = procedurePriceRepository.findById(id);
            if (!procedure.isPresent()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Procedure price not found"));
            }
            
            procedurePriceRepository.delete(procedure.get());
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
    
    
    @PostMapping("/fix-duplicate-ids")
    @ResponseBody
    public ResponseEntity<?> fixDuplicateIds() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // This SQL gets duplicate IDs
            String findDuplicatesSql = "SELECT id, COUNT(*) as count FROM check_in_records GROUP BY id HAVING COUNT(*) > 1";
            List<Map<String, Object>> duplicates = jdbcTemplate.queryForList(findDuplicatesSql);
            
            int fixedIds = 0;
            
            for (Map<String, Object> duplicate : duplicates) {
                Long id = ((Number) duplicate.get("id")).longValue();
                log.info("Found duplicate records for ID: {}", id);
                
                // Get duplicate rows
                String getDuplicatesSql = "SELECT * FROM check_in_records WHERE id = ? ORDER BY check_in_time DESC";
                List<Map<String, Object>> records = jdbcTemplate.queryForList(getDuplicatesSql, id);
                
                if (records.size() > 1) {
                    // Keep first record and delete others
                    for (int i = 1; i < records.size(); i++) {
                        Long recordId = ((Number) records.get(i).get("id")).longValue();
                        
                        // Delete the duplicate directly with SQL
                        String deleteSql = "DELETE FROM check_in_records WHERE id = ? LIMIT 1";
                        int result = jdbcTemplate.update(deleteSql, recordId);
                        
                        if (result > 0) {
                            fixedIds++;
                            log.info("Deleted duplicate check-in record with ID: {}", recordId);
                        }
                    }
                }
            }
            
            response.put("success", true);
            response.put("message", "Fixed " + fixedIds + " duplicate check-in records across " + duplicates.size() + " IDs");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error fixing duplicate record IDs: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    @GetMapping("/fix-database")
    public String fixDatabaseManually() {
        try {
            // Get all duplicates as a set of IDs 
            String findDuplicateIds = "SELECT id FROM check_in_records GROUP BY id HAVING COUNT(*) > 1";
            List<Long> duplicateIds = jdbcTemplate.query(findDuplicateIds, (rs, rowNum) -> rs.getLong("id"));
            
            // For each duplicate ID
            for (Long id : duplicateIds) {
                // Get a reference row ID (one we'll keep)
                String getFirstRowQuery = "SELECT id FROM check_in_records WHERE id = ? LIMIT 1";
                Long referenceId = jdbcTemplate.queryForObject(getFirstRowQuery, Long.class, id);
                
                if (referenceId != null) {
                    // Fix this by assigning new IDs to duplicates
                    String getMaxId = "SELECT MAX(id) FROM check_in_records";
                    Long maxId = jdbcTemplate.queryForObject(getMaxId, Long.class);
                    
                    if (maxId != null) {
                        // Get the number of duplicates
                        String countDuplicatesQuery = "SELECT COUNT(*) FROM check_in_records WHERE id = ?";
                        Integer duplicateCount = jdbcTemplate.queryForObject(countDuplicatesQuery, Integer.class, id);
                        
                        if (duplicateCount != null && duplicateCount > 1) {
                            // Update all but the first row with new sequential IDs
                            int updated = 0;
                            for (int i = 1; i < duplicateCount; i++) {
                                maxId++;
                                String updateQuery = "UPDATE check_in_records " + 
                                                    "SET id = ? " + 
                                                    "WHERE id = ? " + 
                                                    "LIMIT 1";
                                updated += jdbcTemplate.update(updateQuery, maxId, id);
                            }
                            log.info("Updated {} duplicate records for ID {}", updated, id);
                        }
                    }
                }
            }
            
            return "redirect:/admin/database-status?fixed=true";
        } catch (Exception e) {
            log.error("Error fixing database manually: {}", e.getMessage());
            return "redirect:/admin/database-status?error=" + e.getMessage();
        }
    }
} 