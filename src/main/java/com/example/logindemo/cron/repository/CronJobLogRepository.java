package com.example.logindemo.cron.repository;

import com.example.logindemo.cron.model.CronJobHistory;
import com.example.logindemo.cron.model.CronJobLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CronJobLogRepository extends JpaRepository<CronJobLog, Long> {
    List<CronJobLog> findByHistoryOrderByTimestampAsc(CronJobHistory history);
}