package com.example.logindemo.cron.annotation;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface CronJobDefinition {
    String name();
    String cron() default ""; // empty implies manual or DB-config
    boolean active() default true;
    boolean oneTime() default false;
    int maxRetries() default 0;
    int retryDelaySeconds() default 60;
    boolean concurrentAllowed() default false;
    String description() default "";
}