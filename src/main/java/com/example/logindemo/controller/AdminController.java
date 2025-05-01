package com.example.logindemo.controller;

import com.example.logindemo.dto.DoctorDetailDTO;
import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.CityTier;
import com.example.logindemo.model.DoctorDetail;
import com.example.logindemo.model.ProcedurePrice;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.DoctorDetailRepository;
import com.example.logindemo.repository.ProcedurePriceRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.service.DoctorDetailService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
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
        return "admin/create-procedure";
    }
    
    @PostMapping("/prices/create")
    public String createProcedurePrice(@ModelAttribute ProcedurePriceDTO procedureDTO, Model model) {
        try {
            ProcedurePrice procedurePrice = new ProcedurePrice();
            procedurePrice.setProcedureName(procedureDTO.getProcedureName());
            procedurePrice.setCityTier(procedureDTO.getCityTier());
            procedurePrice.setPrice(procedureDTO.getPrice());
            
            procedurePriceRepository.save(procedurePrice);
            return "redirect:/admin/prices?success";
        } catch (Exception e) {
            model.addAttribute("error", "Error creating procedure price: " + e.getMessage());
            model.addAttribute("cityTiers", CityTier.values());
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
        return "admin/edit-procedure";
    }
    
    @PostMapping("/prices/{id}/edit")
    public String updateProcedurePrice(@PathVariable Long id, @ModelAttribute ProcedurePriceDTO procedureDTO, Model model) {
        try {
            Optional<ProcedurePrice> existingProcedure = procedurePriceRepository.findById(id);
            if (!existingProcedure.isPresent()) {
                return "redirect:/admin/prices?error=not-found";
            }
            
            ProcedurePrice procedurePrice = existingProcedure.get();
            procedurePrice.setProcedureName(procedureDTO.getProcedureName());
            procedurePrice.setCityTier(procedureDTO.getCityTier());
            procedurePrice.setPrice(procedureDTO.getPrice());
            
            procedurePriceRepository.save(procedurePrice);
            return "redirect:/admin/prices?success=updated";
        } catch (Exception e) {
            model.addAttribute("error", "Error updating procedure price: " + e.getMessage());
            model.addAttribute("cityTiers", CityTier.values());
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
} 