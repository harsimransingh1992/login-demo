-- Add recipients_csv column to cron_jobs for CSV-based email recipients
ALTER TABLE cron_jobs 
ADD COLUMN recipients_csv TEXT NULL;

-- Optional comment for documentation
COMMENT ON COLUMN cron_jobs.recipients_csv IS 'Comma-separated recipient emails for this cron job';