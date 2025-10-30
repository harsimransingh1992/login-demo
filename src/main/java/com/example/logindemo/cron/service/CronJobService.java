package com.example.logindemo.cron.service;

import com.example.logindemo.cron.model.CronJob;
import com.example.logindemo.cron.model.CronJobHistory;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface CronJobService {
    List<CronJob> listAllJobs();
    Optional<CronJob> getJobById(Long id);
    CronJob createOrUpdate(CronJob job);
    CronJob createOrUpdate(CronJob job, String changedBy);
    void deleteJob(Long id);

    void registerAnnotatedJobs();
    void scheduleActiveJobs();
    void refreshSchedules();

    CronJobHistory triggerJob(Long id, Map<String, Object> parameters, String triggerType);
    boolean pauseJob(Long id);
    boolean resumeJob(Long id);
    boolean stopRunningJob(Long id);

    List<CronJobHistory> getJobHistory(Long id);
}