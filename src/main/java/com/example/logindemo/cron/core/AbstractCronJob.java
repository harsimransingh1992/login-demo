package com.example.logindemo.cron.core;

import com.example.logindemo.cron.model.CronJobLog;
import com.example.logindemo.cron.model.CronJobHistory;
import com.example.logindemo.cron.repository.CronJobLogRepository;
import org.springframework.beans.factory.annotation.Autowired;

public abstract class AbstractCronJob {

    @Autowired
    private CronJobLogRepository logRepository;

    /**
     * Main job logic. Must be implemented by concrete jobs.
     */
    public abstract void perform(CronJobContext context) throws Exception;

    /** Lifecycle hook before perform */
    public void onStart(CronJobContext context) { /* optional */ }

    /** Lifecycle hook after successful perform */
    public void onFinish(CronJobContext context) { /* optional */ }

    /** Lifecycle hook on error */
    public void onError(CronJobContext context, Exception e) { /* optional */ }

    /**
     * Utility to append a log line tied to the current execution.
     */
    protected void log(CronJobContext context, String level, String message) {
        CronJobHistory history = context.getHistory();
        if (history == null) return;
        CronJobLog logEntry = new CronJobLog();
        logEntry.setHistory(history);
        logEntry.setLevel(level);
        logEntry.setMessage(message);
        try {
            logRepository.save(logEntry);
        } catch (Exception ignored) { }
    }
}