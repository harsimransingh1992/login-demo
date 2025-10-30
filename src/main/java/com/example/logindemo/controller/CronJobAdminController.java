package com.example.logindemo.controller;

import com.example.logindemo.cron.model.CronJob;
import com.example.logindemo.cron.model.CronJobHistory;
import com.example.logindemo.cron.model.CronJobLog;
import com.example.logindemo.cron.repository.CronJobLogRepository;
import com.example.logindemo.cron.repository.CronJobConfigChangeRepository;
import com.example.logindemo.cron.service.CronJobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.*;

@Controller
@RequestMapping("/admin/cronjobs")
@PreAuthorize("hasRole('ADMIN')")
public class CronJobAdminController {

    private static final Logger logger = LoggerFactory.getLogger(CronJobAdminController.class);

    @Autowired
    private CronJobService cronJobService;

    @Autowired
    private CronJobLogRepository logRepository;

    @Autowired
    private CronJobConfigChangeRepository configChangeRepository;

    @GetMapping
    public String list(Model model) {
        List<CronJob> jobs = cronJobService.listAllJobs();
        Map<Long, java.time.LocalDateTime> nextRunTimes = new HashMap<>();
        for (CronJob j : jobs) {
            try {
                if (j.isActive() && !j.isPaused() && j.getCronExpression() != null && !j.getCronExpression().isBlank()) {
                    org.springframework.scheduling.support.CronExpression cx = org.springframework.scheduling.support.CronExpression.parse(j.getCronExpression());
                    java.time.LocalDateTime next = cx.next(java.time.LocalDateTime.now());
                    if (next != null) {
                        nextRunTimes.put(j.getId(), next);
                    }
                }
            } catch (Exception e) {
                // ignore invalid cron expressions for listing purposes
            }
        }
        model.addAttribute("jobs", jobs);
        model.addAttribute("nextRunTimes", nextRunTimes);
        return "admin/cronjobs";
    }

    @GetMapping("/{id}/edit")
    public String edit(@PathVariable Long id, Model model) {
        Optional<CronJob> job = cronJobService.getJobById(id);
        if (job.isEmpty()) return "redirect:/admin/cronjobs";
        model.addAttribute("job", job.get());
        model.addAttribute("errors", Collections.emptyMap());
        model.addAttribute("previewTimes", Collections.emptyList());
        return "admin/cronjob-edit";
    }

    @PostMapping("/{id}/edit")
    public String editPost(@PathVariable Long id,
                           @RequestParam(required = false) String description,
                           @RequestParam(required = false) String cronExpression,
                           @RequestParam(required = false) String recipientsCsv,
                           @RequestParam(required = false, defaultValue = "false") boolean active,
                           @RequestParam(required = false, defaultValue = "false") boolean paused,
                           @RequestParam(required = false, defaultValue = "false") boolean oneTime,
                           @RequestParam(required = false, defaultValue = "0") int maxRetries,
                           @RequestParam(required = false, defaultValue = "0") int retryDelaySeconds,
                           @RequestParam(required = false, defaultValue = "false") boolean concurrentAllowed,
                           @RequestParam String action,
                           Model model) {
        Optional<CronJob> opt = cronJobService.getJobById(id);
        if (opt.isEmpty()) return "redirect:/admin/cronjobs";
        CronJob job = opt.get();

        Map<String, String> errors = new HashMap<>();
        if (maxRetries < 0) errors.put("maxRetries", "Max retries must be >= 0");
        if (retryDelaySeconds < 0) errors.put("retryDelaySeconds", "Retry delay must be >= 0");

        if (cronExpression != null) {
            try {
                org.springframework.scheduling.support.CronExpression.parse(cronExpression);
            } catch (Exception e) {
                errors.put("cronExpression", "Invalid cron expression: " + e.getMessage());
            }
        }

        if (recipientsCsv != null && recipientsCsv.length() > 8000) {
            errors.put("recipientsCsv", "Recipients CSV is too long (max 8000 characters)");
        }

        if ("preview".equalsIgnoreCase(action)) {
            List<java.time.LocalDateTime> nextTimes = new ArrayList<>();
            if (!errors.containsKey("cronExpression") && cronExpression != null && !cronExpression.isBlank()) {
                org.springframework.scheduling.support.CronExpression cx = org.springframework.scheduling.support.CronExpression.parse(cronExpression);
                java.time.LocalDateTime base = java.time.LocalDateTime.now();
                for (int i = 0; i < 5; i++) {
                    base = cx.next(base);
                    if (base == null) break;
                    nextTimes.add(base);
                }
            }
            model.addAttribute("job", job);
            model.addAttribute("errors", errors);
            model.addAttribute("previewTimes", nextTimes);
            model.addAttribute("tempDescription", description);
            model.addAttribute("tempCronExpression", cronExpression);
            model.addAttribute("tempActive", active);
            model.addAttribute("tempPaused", paused);
            model.addAttribute("tempOneTime", oneTime);
            model.addAttribute("tempMaxRetries", maxRetries);
            model.addAttribute("tempRetryDelaySeconds", retryDelaySeconds);
            model.addAttribute("tempConcurrentAllowed", concurrentAllowed);
            model.addAttribute("tempRecipientsCsv", recipientsCsv);
            return "admin/cronjob-edit";
        }

        if (!errors.isEmpty()) {
            model.addAttribute("job", job);
            model.addAttribute("errors", errors);
            model.addAttribute("previewTimes", Collections.emptyList());
            return "admin/cronjob-edit";
        }

        job.setDescription(description);
        if (cronExpression != null) job.setCronExpression(cronExpression);
        job.setActive(active);
        job.setPaused(paused);
        job.setOneTime(oneTime);
        job.setMaxRetries(maxRetries);
        job.setRetryDelaySeconds(retryDelaySeconds);
        job.setConcurrentAllowed(concurrentAllowed);
        job.setRecipientsCsv(recipientsCsv);

        String username = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getName();
        cronJobService.createOrUpdate(job, username);
        return "redirect:/admin/cronjobs";
    }

    @PostMapping("/{id}/trigger")
    public String trigger(@PathVariable Long id, @RequestParam Map<String, Object> params) {
        Map<String, Object> p = params != null ? params : Collections.emptyMap();
        cronJobService.triggerJob(id, p, "MANUAL");
        return "redirect:/admin/cronjobs";
    }

    @PostMapping("/{id}/pause")
    public String pause(@PathVariable Long id) {
        cronJobService.pauseJob(id);
        return "redirect:/admin/cronjobs";
    }

    @PostMapping("/{id}/resume")
    public String resume(@PathVariable Long id) {
        cronJobService.resumeJob(id);
        return "redirect:/admin/cronjobs";
    }

    @PostMapping("/{id}/stop")
    public String stop(@PathVariable Long id) {
        cronJobService.stopRunningJob(id);
        return "redirect:/admin/cronjobs";
    }

    @PostMapping("/refresh")
    public String refresh() {
        String username = null;
        try {
            username = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication() != null ?
                    org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getName() : "anonymous";
        } catch (Exception ignored) { username = "anonymous"; }
        logger.info("Admin '{}' triggered cron job registrations refresh.", username);
        cronJobService.registerAnnotatedJobs();
        logger.info("Cron job registrations refresh completed (admin '{}').", username);
        return "redirect:/admin/cronjobs";
    }

    @GetMapping("/{id}/history")
    public String history(@PathVariable Long id, Model model) {
        Optional<CronJob> job = cronJobService.getJobById(id);
        if (job.isEmpty()) return "redirect:/admin/cronjobs";
        List<CronJobHistory> histories = cronJobService.getJobHistory(id);
        model.addAttribute("job", job.get());
        model.addAttribute("histories", histories);
        return "admin/cronjob-history";
    }

    @GetMapping("/{id}/config-history")
    public String configHistory(@PathVariable Long id, Model model) {
        Optional<CronJob> job = cronJobService.getJobById(id);
        if (job.isEmpty()) return "redirect:/admin/cronjobs";
        List<com.example.logindemo.cron.model.CronJobConfigChange> changes = configChangeRepository.findByCronJobOrderByChangedAtDesc(job.get());
        model.addAttribute("job", job.get());
        model.addAttribute("changes", changes);
        return "admin/cronjob-config-history";
    }

    @PostMapping("/config-history/{changeId}/rollback")
    public String rollback(@PathVariable Long changeId) {
        com.example.logindemo.cron.model.CronJobConfigChange change = configChangeRepository.findById(changeId).orElse(null);
        if (change == null) return "redirect:/admin/cronjobs";
        CronJob job = change.getCronJob();
        String field = change.getFieldName();
        String oldVal = change.getOldValue();
        if (field != null) {
            switch (field) {
                case "cronExpression": job.setCronExpression(oldVal); break;
                case "active": job.setActive(Boolean.parseBoolean(oldVal)); break;
                case "paused": job.setPaused(Boolean.parseBoolean(oldVal)); break;
                case "oneTime": job.setOneTime(Boolean.parseBoolean(oldVal)); break;
                case "maxRetries": job.setMaxRetries(parseIntSafe(oldVal, job.getMaxRetries())); break;
                case "retryDelaySeconds": job.setRetryDelaySeconds(parseIntSafe(oldVal, job.getRetryDelaySeconds())); break;
                case "concurrentAllowed": job.setConcurrentAllowed(Boolean.parseBoolean(oldVal)); break;
                case "description": job.setDescription(oldVal); break;
                case "recipientsCsv": job.setRecipientsCsv(oldVal); break;
                default: break;
            }
        }
        String username = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getName();
        CronJob saved = cronJobService.createOrUpdate(job, username);
        com.example.logindemo.cron.model.CronJobConfigChange rollbackMarker = new com.example.logindemo.cron.model.CronJobConfigChange();
        rollbackMarker.setCronJob(saved);
        rollbackMarker.setFieldName("ROLLBACK:" + field);
        rollbackMarker.setOldValue(change.getNewValue());
        rollbackMarker.setNewValue(change.getOldValue());
        rollbackMarker.setChangedBy(username);
        rollbackMarker.setRollbackOfChangeId(change.getId());
        configChangeRepository.save(rollbackMarker);
        return "redirect:/admin/cronjobs/" + job.getId() + "/config-history";
    }

    private int parseIntSafe(String s, int fallback) {
        try { return Integer.parseInt(s); } catch (Exception e) { return fallback; }
    }

    @GetMapping("/history/{historyId}/logs")
    public String historyLogs(@PathVariable Long historyId, Model model) {
        CronJobHistory h = new CronJobHistory();
        h.setId(historyId);
        List<CronJobLog> logs = logRepository.findByHistoryOrderByTimestampAsc(h);
        model.addAttribute("historyId", historyId);
        model.addAttribute("logs", logs);
        return "admin/cronjob-logs";
    }
}