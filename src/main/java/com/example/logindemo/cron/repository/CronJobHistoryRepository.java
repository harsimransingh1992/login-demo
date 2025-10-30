package com.example.logindemo.cron.repository;

import com.example.logindemo.cron.model.CronJob;
import com.example.logindemo.cron.model.CronJobHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CronJobHistoryRepository extends JpaRepository<CronJobHistory, Long> {
    List<CronJobHistory> findByCronJobOrderByStartTimeDesc(CronJob cronJob);
}