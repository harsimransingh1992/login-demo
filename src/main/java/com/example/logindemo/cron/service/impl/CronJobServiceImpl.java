package com.example.logindemo.cron.service.impl;

import com.example.logindemo.cron.CronJobStatus;
import com.example.logindemo.cron.annotation.CronJobDefinition;
import com.example.logindemo.cron.core.AbstractCronJob;
import com.example.logindemo.cron.core.CronJobContext;
import com.example.logindemo.cron.model.CronJob;
import com.example.logindemo.cron.model.CronJobHistory;
import com.example.logindemo.cron.model.CronJobConfigChange;
import com.example.logindemo.cron.repository.CronJobHistoryRepository;
import com.example.logindemo.cron.repository.CronJobLogRepository;
import com.example.logindemo.cron.repository.CronJobRepository;
import com.example.logindemo.cron.repository.CronJobConfigChangeRepository;
import com.example.logindemo.cron.service.CronJobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.util.ClassUtils;
import javax.annotation.PostConstruct;
import org.springframework.context.ApplicationContext;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Future;

@Service
public class CronJobServiceImpl implements CronJobService {

    private static final Logger logger = LoggerFactory.getLogger(CronJobServiceImpl.class);

    @Autowired
    private ApplicationContext applicationContext;

    @Autowired
    private CronJobRepository jobRepository;

    @Autowired
    private CronJobHistoryRepository historyRepository;

    @Autowired
    private CronJobLogRepository logRepository;

    @Autowired
    private CronJobConfigChangeRepository configChangeRepository;

    @Autowired
    @Qualifier("cronJobTaskScheduler")
    private TaskScheduler taskScheduler;

    @Autowired
    @Qualifier("cronJobTaskExecutor")
    private ThreadPoolTaskExecutor taskExecutor;

    private final Map<Long, Future<?>> runningJobs = new ConcurrentHashMap<>();
    private final Map<Long, java.util.concurrent.ScheduledFuture<?>> scheduledFutures = new ConcurrentHashMap<>();

    @PostConstruct
    public void init() {
        // Register annotated jobs and schedule active ones on startup
        logger.info("CronJobService initialized: registering annotated jobs and scheduling active ones.");
        registerAnnotatedJobs();
    }

    @Override
    public List<CronJob> listAllJobs() {
        return jobRepository.findAll();
    }

    @Override
    public Optional<CronJob> getJobById(Long id) {
        return jobRepository.findById(id);
    }

    @Override
    public CronJob createOrUpdate(CronJob job) {
        job.setUpdatedAt(LocalDateTime.now());
        boolean isNew = (job.getId() == null);
        CronJob before = null;
        if (!isNew) {
            before = jobRepository.findById(job.getId()).orElse(null);
        }
        CronJob saved = jobRepository.save(job);
        if (before != null) {
            auditChanges(before, saved, "SYSTEM");
        }
        refreshSchedules();
        return saved;
    }

    @Override
    public CronJob createOrUpdate(CronJob job, String changedBy) {
        job.setUpdatedAt(LocalDateTime.now());
        boolean isNew = (job.getId() == null);
        CronJob before = null;
        if (!isNew) {
            before = jobRepository.findById(job.getId()).orElse(null);
        }
        CronJob saved = jobRepository.save(job);
        if (before != null) {
            auditChanges(before, saved, changedBy == null ? "SYSTEM" : changedBy);
        }
        refreshSchedules();
        return saved;
    }

    @Override
    public void deleteJob(Long id) {
        stopRunningJob(id);
        cancelSchedule(id);
        jobRepository.deleteById(id);
    }

    @Override
    @Transactional
    public void registerAnnotatedJobs() {
        logger.info("Refreshing cron job registrations: scanning ApplicationContext for AbstractCronJob beans.");
        Map<String, AbstractCronJob> beans = applicationContext.getBeansOfType(AbstractCronJob.class);
        logger.info("Found {} AbstractCronJob beans for potential registration.", beans.size());
        int registeredCount = 0;
        for (Map.Entry<String, AbstractCronJob> entry : beans.entrySet()) {
            String beanName = entry.getKey();
            AbstractCronJob jobBean = entry.getValue();
            logger.info("Discovered cron bean '{}' of class '{}'", beanName, jobBean.getClass().getName());
            Class<?> targetClass = ClassUtils.getUserClass(jobBean);
            logger.info("Resolved target class '{}' for bean '{}'", targetClass.getName(), beanName);
            CronJobDefinition def = AnnotationUtils.findAnnotation(targetClass, CronJobDefinition.class);
            if (def == null) {
                logger.info("Skipping bean '{}' (no @CronJobDefinition present on resolved target class '{}').", beanName, targetClass.getName());
                continue;
            }
            logger.info("Definition for bean '{}' -> name='{}' cron='{}' active={}", beanName, def.name(), def.cron(), def.active());

            Optional<CronJob> existing = jobRepository.findByName(def.name());
            CronJob job = existing.orElseGet(CronJob::new);
            job.setName(def.name());
            job.setDescription(def.description());
            job.setBeanName(beanName);
            job.setCronExpression(def.cron());
            job.setActive(def.active());
            job.setOneTime(def.oneTime());
            job.setMaxRetries(def.maxRetries());
            job.setRetryDelaySeconds(def.retryDelaySeconds());
            job.setConcurrentAllowed(def.concurrentAllowed());
            job.setUpdatedAt(LocalDateTime.now());
            if (job.getCreatedAt() == null) job.setCreatedAt(LocalDateTime.now());
            boolean isNew = !existing.isPresent();
            logger.info("Registering job '{}' from bean '{}' ({}).", def.name(), beanName, isNew ? "new" : "update");
            CronJob saved = jobRepository.save(job);
            registeredCount++;
            logger.debug("Saved job '{}' with id={} active={} cron='{}'", saved.getName(), saved.getId(), saved.isActive(), saved.getCronExpression());
        }
        logger.info("Completed registration for {} job(s). Refreshing schedules.", registeredCount);
        refreshSchedules();
        logger.info("Schedules refreshed for active jobs.");
    }

    @Override
    public void scheduleActiveJobs() {
        List<CronJob> activeJobs = jobRepository.findByActiveTrue();
        for (CronJob job : activeJobs) {
            scheduleJob(job);
        }
    }

    @Override
    public void refreshSchedules() {
        // Cancel existing schedules then re-schedule
        for (Long jobId : new ArrayList<>(scheduledFutures.keySet())) {
            cancelSchedule(jobId);
        }
        scheduleActiveJobs();
    }

    private void scheduleJob(CronJob job) {
        if (job.isPaused() || job.getCronExpression() == null || job.getCronExpression().isBlank()) return;
        cancelSchedule(job.getId());
        CronTrigger trigger = new CronTrigger(job.getCronExpression());
        java.util.concurrent.ScheduledFuture<?> future = taskScheduler.schedule(() -> {
            try {
                triggerJob(job.getId(), Collections.emptyMap(), "SCHEDULED");
            } catch (Exception ignored) {}
        }, trigger);
        if (future != null) {
            scheduledFutures.put(job.getId(), future);
        }
    }

    private void cancelSchedule(Long jobId) {
        java.util.concurrent.ScheduledFuture<?> f = scheduledFutures.remove(jobId);
        if (f != null) f.cancel(false);
    }

    @Override
    @Transactional
    public CronJobHistory triggerJob(Long id, Map<String, Object> parameters, String triggerType) {
        CronJob job = jobRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("CronJob not found"));
        if (job.isPaused() || !job.isActive()) throw new IllegalStateException("Job is not active or is paused");
        if (!job.isConcurrentAllowed() && runningJobs.containsKey(id)) {
            throw new IllegalStateException("Job is already running");
        }

        AbstractCronJob bean = (AbstractCronJob) applicationContext.getBean(job.getBeanName());
        CronJobHistory history = new CronJobHistory();
        history.setCronJob(job);
        history.setStatus(CronJobStatus.RUNNING);
        history.setStartTime(LocalDateTime.now());
        history.setRetryAttempt(0);
        history.setTriggerType(triggerType);
        history = historyRepository.save(history);

        job.setLastRunStart(history.getStartTime());
        job.setLastStatus(CronJobStatus.RUNNING);
        jobRepository.save(job);

        CronJobContext context = new CronJobContext(job, history, parameters);

        final AbstractCronJob jobBean = bean;
        final CronJob savedJob = job;
        final CronJobHistory savedHistory = history;
        final CronJobContext savedContext = context;
        Future<?> future = taskExecutor.submit(() -> executeJob(jobBean, savedJob, savedHistory, savedContext));
        runningJobs.put(id, future);
        return history;
    }

    private void executeJob(AbstractCronJob bean, CronJob job, CronJobHistory history, CronJobContext context) {
        try {
            bean.onStart(context);
            bean.perform(context);
            bean.onFinish(context);
            completeHistorySuccess(job, history, "Success");
        } catch (Exception e) {
            bean.onError(context, e);
            boolean willRetry = scheduleRetryIfApplicable(job, history, context, e);
            if (!willRetry) {
                completeHistoryFailure(job, history, e);
            }
        } finally {
            runningJobs.remove(job.getId());
            if (job.isOneTime()) {
                job.setActive(false);
                cancelSchedule(job.getId());
                jobRepository.save(job);
            }
        }
    }

    private void completeHistorySuccess(CronJob job, CronJobHistory history, String summary) {
        history.setEndTime(LocalDateTime.now());
        history.setDurationMs(java.time.Duration.between(history.getStartTime(), history.getEndTime()).toMillis());
        history.setStatus(CronJobStatus.FINISHED);
        history.setResultSummary(summary);
        historyRepository.save(history);
        job.setLastRunEnd(history.getEndTime());
        job.setLastStatus(CronJobStatus.FINISHED);
        jobRepository.save(job);
    }

    private void completeHistoryFailure(CronJob job, CronJobHistory history, Exception e) {
        history.setEndTime(LocalDateTime.now());
        history.setDurationMs(java.time.Duration.between(history.getStartTime(), history.getEndTime()).toMillis());
        history.setStatus(CronJobStatus.FAILED);
        history.setErrorMessage(e.getMessage());
        history.setStackTrace(stackTraceToString(e));
        historyRepository.save(history);
        job.setLastRunEnd(history.getEndTime());
        job.setLastStatus(CronJobStatus.FAILED);
        jobRepository.save(job);
    }

    private boolean scheduleRetryIfApplicable(CronJob job, CronJobHistory history, CronJobContext context, Exception e) {
        int attempt = history.getRetryAttempt() != null ? history.getRetryAttempt() : 0;
        int max = job.getMaxRetries() != null ? job.getMaxRetries() : 0;
        int delay = job.getRetryDelaySeconds() != null ? job.getRetryDelaySeconds() : 60;
        if (attempt >= max) return false;

        // Create a new history for retry
        CronJobHistory retryHistory = new CronJobHistory();
        retryHistory.setCronJob(job);
        retryHistory.setStatus(CronJobStatus.PENDING);
        retryHistory.setRetryAttempt(attempt + 1);
        retryHistory.setTriggerType("RETRY");
        retryHistory = historyRepository.save(retryHistory);

        final CronJob savedJob = job;
        final CronJobHistory savedRetryHistory = retryHistory;
        final Map<String, Object> params = context.getParameters();
        taskScheduler.schedule(() -> {
            CronJobContext retryContext = new CronJobContext(savedJob, savedRetryHistory, params);
            Future<?> future = taskExecutor.submit(() -> executeJob((AbstractCronJob) applicationContext.getBean(savedJob.getBeanName()), savedJob, savedRetryHistory, retryContext));
            runningJobs.put(savedJob.getId(), future);
        }, new java.util.Date(System.currentTimeMillis() + delay * 1000L));

        return true;
    }

    private String stackTraceToString(Exception e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }

    @Override
    public boolean pauseJob(Long id) {
        Optional<CronJob> opt = jobRepository.findById(id);
        if (opt.isEmpty()) return false;
        CronJob job = opt.get();
        job.setPaused(true);
        jobRepository.save(job);
        cancelSchedule(id);
        return true;
    }

    @Override
    public boolean resumeJob(Long id) {
        Optional<CronJob> opt = jobRepository.findById(id);
        if (opt.isEmpty()) return false;
        CronJob job = opt.get();
        job.setPaused(false);
        jobRepository.save(job);
        scheduleJob(job);
        return true;
    }

    @Override
    public boolean stopRunningJob(Long id) {
        Future<?> future = runningJobs.get(id);
        if (future == null) return false;
        boolean cancelled = future.cancel(true);
        runningJobs.remove(id);
        return cancelled;
    }

    @Override
    public List<CronJobHistory> getJobHistory(Long id) {
        CronJob job = jobRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("CronJob not found"));
        return historyRepository.findByCronJobOrderByStartTimeDesc(job);
    }
    
    private void auditChanges(CronJob before, CronJob after, String changedBy) {
        // Compare relevant fields and write audit entries when changed
        recordChangeIfDifferent(before.getCronExpression(), after.getCronExpression(), "cronExpression", after, changedBy);
        recordChangeIfDifferent(String.valueOf(before.isActive()), String.valueOf(after.isActive()), "active", after, changedBy);
        recordChangeIfDifferent(String.valueOf(before.isPaused()), String.valueOf(after.isPaused()), "paused", after, changedBy);
        recordChangeIfDifferent(String.valueOf(before.isOneTime()), String.valueOf(after.isOneTime()), "oneTime", after, changedBy);
        recordChangeIfDifferent(String.valueOf(before.getMaxRetries()), String.valueOf(after.getMaxRetries()), "maxRetries", after, changedBy);
        recordChangeIfDifferent(String.valueOf(before.getRetryDelaySeconds()), String.valueOf(after.getRetryDelaySeconds()), "retryDelaySeconds", after, changedBy);
        recordChangeIfDifferent(String.valueOf(before.isConcurrentAllowed()), String.valueOf(after.isConcurrentAllowed()), "concurrentAllowed", after, changedBy);
        recordChangeIfDifferent(before.getDescription(), after.getDescription(), "description", after, changedBy);
        recordChangeIfDifferent(before.getRecipientsCsv(), after.getRecipientsCsv(), "recipientsCsv", after, changedBy);
    }

    private void recordChangeIfDifferent(String oldVal, String newVal, String field, CronJob job, String changedBy) {
        String ov = oldVal == null ? "" : oldVal;
        String nv = newVal == null ? "" : newVal;
        if (Objects.equals(ov, nv)) return;
        CronJobConfigChange change = new CronJobConfigChange();
        change.setCronJob(job);
        change.setFieldName(field);
        change.setOldValue(oldVal);
        change.setNewValue(newVal);
        change.setChangedBy(changedBy);
        change.setChangedAt(LocalDateTime.now());
        configChangeRepository.save(change);
    }
}