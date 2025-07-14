package com.example.logindemo.controller;

import com.example.logindemo.dto.ClinicDTO;
import com.example.logindemo.service.ClinicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/clinics")
public class ClinicController {

    @Autowired
    private ClinicService clinicService;

    @GetMapping
    public String getAllClinics(Model model) {
        List<ClinicDTO> clinics = clinicService.getAllClinics();
        model.addAttribute("clinics", clinics);
        return "clinic/clinicList";
    }

    @GetMapping("/{id}")
    public String getClinicById(@PathVariable Long id, Model model) {
        return clinicService.getClinicById(id)
            .map(clinic -> {
                model.addAttribute("clinic", clinic);
                return "clinic/clinicDetails";
            })
            .orElse("redirect:/clinics?error=Clinic+not+found");
    }

    @GetMapping("/new")
    public String showCreateClinicForm(Model model) {
        model.addAttribute("clinic", new ClinicDTO());
        return "clinic/createClinic";
    }

    @PostMapping
    public String createClinic(@ModelAttribute ClinicDTO clinicDTO) {
        clinicService.createClinic(clinicDTO);
        return "redirect:/clinics";
    }

    @GetMapping("/{id}/edit")
    public String showEditClinicForm(@PathVariable Long id, Model model) {
        return clinicService.getClinicById(id)
            .map(clinic -> {
                model.addAttribute("clinic", clinic);
                return "clinic/editClinic";
            })
            .orElse("redirect:/clinics?error=Clinic+not+found");
    }

    @PostMapping("/{id}")
    public String updateClinic(@PathVariable Long id, @ModelAttribute ClinicDTO clinicDTO) {
        clinicService.updateClinic(id, clinicDTO);
        return "redirect:/clinics/" + id;
    }

    @PostMapping("/{id}/delete")
    public String deleteClinic(@PathVariable Long id) {
        clinicService.deleteClinic(id);
        return "redirect:/clinics";
    }

    // REST API endpoints for programmatic access
    @GetMapping("/api")
    @ResponseBody
    public ResponseEntity<List<ClinicDTO>> getAllClinicsApi() {
        List<ClinicDTO> clinics = clinicService.getAllClinics();
        return ResponseEntity.ok(clinics);
    }

    @GetMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<ClinicDTO> getClinicByIdApi(@PathVariable Long id) {
        return clinicService.getClinicById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/api")
    @ResponseBody
    public ResponseEntity<ClinicDTO> createClinicApi(@RequestBody ClinicDTO clinicDTO) {
        ClinicDTO createdClinic = clinicService.createClinic(clinicDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdClinic);
    }

    @PutMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<ClinicDTO> updateClinicApi(@PathVariable Long id, @RequestBody ClinicDTO clinicDTO) {
        try {
            ClinicDTO updatedClinic = clinicService.updateClinic(id, clinicDTO);
            return ResponseEntity.ok(updatedClinic);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<Void> deleteClinicApi(@PathVariable Long id) {
        clinicService.deleteClinic(id);
        return ResponseEntity.noContent().build();
    }
} 