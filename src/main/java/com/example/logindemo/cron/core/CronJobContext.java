package com.example.logindemo.cron.core;

import com.example.logindemo.cron.model.CronJob;
import com.example.logindemo.cron.model.CronJobHistory;

import java.util.Collections;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

public class CronJobContext {
    private final CronJob job;
    private final CronJobHistory history;
    private final Map<String, Object> parameters;
    private final AtomicBoolean abortRequested = new AtomicBoolean(false);

    public CronJobContext(CronJob job, CronJobHistory history, Map<String, Object> parameters) {
        this.job = job;
        this.history = history;
        this.parameters = parameters != null ? parameters : Collections.emptyMap();
    }

    public CronJob getJob() { return job; }
    public CronJobHistory getHistory() { return history; }
    public Map<String, Object> getParameters() { return parameters; }
    public boolean isAbortRequested() { return abortRequested.get(); }
    public void requestAbort() { abortRequested.set(true); }
}