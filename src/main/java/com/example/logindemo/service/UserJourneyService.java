package com.example.logindemo.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
public class UserJourneyService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @PostConstruct
    public void initSchema() {
        jdbcTemplate.execute(
            "CREATE TABLE IF NOT EXISTS user_event_log (" +
            " id BIGINT AUTO_INCREMENT PRIMARY KEY," +
            " patient_id BIGINT NULL," +
            " patient_name VARCHAR(255) NULL," +
            " clinic_id BIGINT NULL," +
            " clinic_name VARCHAR(255) NULL," +
            " doctor_id BIGINT NULL," +
            " doctor_name VARCHAR(255) NULL," +
            " appointment_id BIGINT NULL," +
            " event_type VARCHAR(64) NOT NULL," +
            " event_status VARCHAR(64) NULL," +
            " event_desc VARCHAR(1024) NULL," +
            " amount DECIMAL(12,2) NULL," +
            " metadata_json TEXT NULL," +
            " created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            " INDEX idx_patient_id (patient_id)," +
            " INDEX idx_event_type (event_type)," +
            " INDEX idx_created_at (created_at)" +
            ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
        );
    }

    public void logEvent(Map<String, Object> payload) {
        String metadataJson = null;
        try {
            metadataJson = payload.containsKey("metadata") && payload.get("metadata") != null
                ? objectMapper.writeValueAsString(payload.get("metadata"))
                : null;
        } catch (Exception ignore) {}

        jdbcTemplate.update(
            "INSERT INTO user_event_log (patient_id, patient_name, clinic_id, clinic_name, doctor_id, doctor_name, " +
            " appointment_id, event_type, event_status, event_desc, amount, metadata_json, created_at) " +
            " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            payload.get("patientId"),
            payload.get("patientName"),
            payload.get("clinicId"),
            payload.get("clinicName"),
            payload.get("doctorId"),
            payload.get("doctorName"),
            payload.get("appointmentId"),
            payload.get("eventType"),
            payload.get("eventStatus"),
            payload.get("eventDesc"),
            payload.get("amount"),
            metadataJson,
            payload.getOrDefault("createdAt", LocalDateTime.now())
        );
    }

    public List<Map<String, Object>> getEvents(Long patientId, String eventType, LocalDateTime from, LocalDateTime to) {
        StringBuilder sql = new StringBuilder("SELECT * FROM user_event_log WHERE 1=1");
        java.util.List<Object> params = new java.util.ArrayList<>();
        if (patientId != null) { sql.append(" AND patient_id = ?"); params.add(patientId); }
        if (eventType != null && !eventType.isEmpty()) { sql.append(" AND event_type = ?"); params.add(eventType); }
        if (from != null) { sql.append(" AND created_at >= ?"); params.add(java.sql.Timestamp.valueOf(from)); }
        if (to != null) { sql.append(" AND created_at <= ?"); params.add(java.sql.Timestamp.valueOf(to)); }
        sql.append(" ORDER BY created_at DESC LIMIT 1000");

        return jdbcTemplate.query(sql.toString(), params.toArray(), new RowMapper<Map<String,Object>>() {
            @Override
            public Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
                java.util.Map<String, Object> m = new java.util.HashMap<>();
                m.put("id", rs.getLong("id"));
                m.put("patientId", rs.getObject("patient_id"));
                m.put("patientName", rs.getString("patient_name"));
                m.put("clinicId", rs.getObject("clinic_id"));
                m.put("clinicName", rs.getString("clinic_name"));
                m.put("doctorId", rs.getObject("doctor_id"));
                m.put("doctorName", rs.getString("doctor_name"));
                m.put("appointmentId", rs.getObject("appointment_id"));
                m.put("eventType", rs.getString("event_type"));
                m.put("eventStatus", rs.getString("event_status"));
                m.put("eventDesc", rs.getString("event_desc"));
                m.put("amount", rs.getBigDecimal("amount"));
                m.put("metadataJson", rs.getString("metadata_json"));
                m.put("createdAt", rs.getTimestamp("created_at").toLocalDateTime());
                return m;
            }
        });
    }

    public List<Map<String, Object>> getEventsAdvanced(Long patientId, java.util.List<String> eventTypes,
                                                       LocalDateTime from, LocalDateTime to, String searchText) {
        StringBuilder sql = new StringBuilder("SELECT * FROM user_event_log WHERE 1=1");
        java.util.List<Object> params = new java.util.ArrayList<>();
        if (patientId != null) { sql.append(" AND patient_id = ?"); params.add(patientId); }
        if (eventTypes != null && !eventTypes.isEmpty()) {
            sql.append(" AND event_type IN (");
            sql.append(eventTypes.stream().map(e -> "?").collect(java.util.stream.Collectors.joining(",")));
            sql.append(")");
            params.addAll(eventTypes);
        }
        if (from != null) { sql.append(" AND created_at >= ?"); params.add(java.sql.Timestamp.valueOf(from)); }
        if (to != null) { sql.append(" AND created_at <= ?"); params.add(java.sql.Timestamp.valueOf(to)); }
        if (searchText != null && !searchText.isEmpty()) {
            sql.append(" AND (LOWER(event_desc) LIKE ? OR LOWER(metadata_json) LIKE ?)");
            String s = "%" + searchText.toLowerCase() + "%";
            params.add(s);
            params.add(s);
        }
        sql.append(" ORDER BY created_at DESC LIMIT 1000");

        return jdbcTemplate.query(sql.toString(), params.toArray(), new RowMapper<Map<String,Object>>() {
            @Override
            public Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
                java.util.Map<String, Object> m = new java.util.HashMap<>();
                m.put("id", rs.getLong("id"));
                m.put("patientId", rs.getObject("patient_id"));
                m.put("patientName", rs.getString("patient_name"));
                m.put("clinicId", rs.getObject("clinic_id"));
                m.put("clinicName", rs.getString("clinic_name"));
                m.put("doctorId", rs.getObject("doctor_id"));
                m.put("doctorName", rs.getString("doctor_name"));
                m.put("appointmentId", rs.getObject("appointment_id"));
                m.put("eventType", rs.getString("event_type"));
                m.put("eventStatus", rs.getString("event_status"));
                m.put("eventDesc", rs.getString("event_desc"));
                m.put("amount", rs.getBigDecimal("amount"));
                m.put("metadataJson", rs.getString("metadata_json"));
                m.put("createdAt", rs.getTimestamp("created_at").toLocalDateTime());
                return m;
            }
        });
    }
}