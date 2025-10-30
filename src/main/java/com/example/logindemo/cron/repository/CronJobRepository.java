package com.example.logindemo.cron.repository;

import com.example.logindemo.cron.model.CronJob;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CronJobRepository extends JpaRepository<CronJob, Long> {
    Optional<CronJob> findByName(String name);
    Optional<CronJob> findByBeanName(String beanName);
    List<CronJob> findByActiveTrue();
}