package com.example.logindemo.service.report.provider;

import java.util.Map;

/**
 * Standard interface for providers that produce canonical JSON data for reports.
 * Providers focus on data retrieval and aggregation only; generators handle presentation.
 */
public interface ReportDataProvider {

    /**
     * Build canonical JSON data for a report using provided parameters.
     * @param parameters normalized or raw parameters (provider should normalize as needed)
     * @return canonical JSON map for the report
     */
    Map<String, Object> getData(Map<String, Object> parameters);

    /**
     * Identifier for the report type this provider supplies.
     */
    String getReportType();

    /**
     * Schema version of the JSON returned by this provider.
     */
    String getSchemaVersion();
}