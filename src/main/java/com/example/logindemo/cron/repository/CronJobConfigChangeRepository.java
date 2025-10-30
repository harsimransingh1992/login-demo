package com.example.logindemo.cron.repository;

import com.example.logindemo.cron.model.CronJob;
import com.example.logindemo.cron.model.CronJobConfigChange;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CronJobConfigChangeRepository extends JpaRepository<CronJobConfigChange, Long> {
    List<CronJobConfigChange> findByCronJobOrderByChangedAtDesc(CronJob cronJob);
}