package com.example.logindemo.cron.jobs;

import com.example.logindemo.cron.annotation.CronJobDefinition;
import com.example.logindemo.cron.core.AbstractCronJob;
import com.example.logindemo.cron.core.CronJobContext;
import org.springframework.stereotype.Component;

@Component("exampleCleanupJob")
@CronJobDefinition(
        name = "ExampleCleanupJob",
        description = "Example job that simulates cleanup work and logs progress",
        cron = "0 */5 * * * *", // every 5 minutes
        active = true,
        oneTime = false,
        maxRetries = 2,
        retryDelaySeconds = 30,
        concurrentAllowed = false
)
public class ExampleCleanupJob extends AbstractCronJob {

    @Override
    public void onStart(CronJobContext context) {
        log(context, "INFO", "Cleanup job starting for: " + context.getJob().getName());
    }

    @Override
    public void perform(CronJobContext context) throws Exception {
        // Simulate work with logs and a sleep
        log(context, "INFO", "Scanning temporary storage...");
        Thread.sleep(500);
        log(context, "INFO", "Deleting orphaned files...");
        Thread.sleep(500);
        log(context, "INFO", "Compacting remaining files...");
        Thread.sleep(500);

        // Example parameter usage
        Object dryRun = context.getParameters().getOrDefault("dryRun", false);
        log(context, "INFO", "Dry run: " + dryRun);
    }

    @Override
    public void onFinish(CronJobContext context) {
        log(context, "INFO", "Cleanup job finished successfully.");
    }

    @Override
    public void onError(CronJobContext context, Exception e) {
        log(context, "ERROR", "Cleanup job failed: " + e.getMessage());
    }
}