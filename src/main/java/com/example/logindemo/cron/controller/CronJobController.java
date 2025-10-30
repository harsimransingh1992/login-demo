package com.example.logindemo.cron.controller;

import com.example.logindemo.cron.model.CronJob;
import com.example.logindemo.cron.model.CronJobHistory;
import com.example.logindemo.cron.model.CronJobLog;
import com.example.logindemo.cron.repository.CronJobLogRepository;
import com.example.logindemo.cron.service.CronJobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/cronjobs")
public class CronJobController {

    private static final Logger logger = LoggerFactory.getLogger(CronJobController.class);

    @Autowired
    private CronJobService cronJobService;

    @Autowired
    private CronJobLogRepository logRepository;

    @GetMapping
    public List<CronJob> listAll() {
        return cronJobService.listAllJobs();
    }

    @GetMapping("/{id}")
    public ResponseEntity<CronJob> get(@PathVariable Long id) {
        Optional<CronJob> job = cronJobService.getJobById(id);
        return job.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public CronJob create(@RequestBody CronJob job) {
        return cronJobService.createOrUpdate(job);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CronJob> update(@PathVariable Long id, @RequestBody CronJob job) {
        job.setId(id);
        return ResponseEntity.ok(cronJobService.createOrUpdate(job));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        cronJobService.deleteJob(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/trigger")
    public ResponseEntity<CronJobHistory> trigger(@PathVariable Long id, @RequestBody(required = false) Map<String, Object> params) {
        CronJobHistory h = cronJobService.triggerJob(id, params, "MANUAL");
        return ResponseEntity.ok(h);
    }

    @PostMapping("/refresh")
    public ResponseEntity<Map<String, Object>> refresh() {
        logger.info("API refresh of cron job registrations invoked.");
        cronJobService.registerAnnotatedJobs();
        logger.info("API refresh of cron job registrations completed.");
        return ResponseEntity.ok(Map.of("success", true));
    }

    @PostMapping("/{id}/pause")
    public ResponseEntity<Map<String, Object>> pause(@PathVariable Long id) {
        boolean ok = cronJobService.pauseJob(id);
        return ResponseEntity.ok(Map.of("success", ok));
    }

    @PostMapping("/{id}/resume")
    public ResponseEntity<Map<String, Object>> resume(@PathVariable Long id) {
        boolean ok = cronJobService.resumeJob(id);
        return ResponseEntity.ok(Map.of("success", ok));
    }

    @PostMapping("/{id}/stop")
    public ResponseEntity<Map<String, Object>> stop(@PathVariable Long id) {
        boolean ok = cronJobService.stopRunningJob(id);
        return ResponseEntity.ok(Map.of("success", ok));
    }

    @GetMapping("/{id}/history")
    public ResponseEntity<List<CronJobHistory>> history(@PathVariable Long id) {
        return ResponseEntity.ok(cronJobService.getJobHistory(id));
    }

    @GetMapping("/history/{historyId}/logs")
    public ResponseEntity<List<CronJobLog>> logs(@PathVariable Long historyId) {
        // Simple pass-through for logs
        return ResponseEntity.ok(logRepository.findByHistoryOrderByTimestampAsc(new CronJobHistory() {{ setId(historyId); }}));
    }
}