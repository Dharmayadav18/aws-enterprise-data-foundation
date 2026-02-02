-- Batch validation checks for enterprise batch pipelines
-- Author: Dharmendra
-- Purpose: Validate completeness and freshness before publishing data

-- Record count validation
SELECT
    batch_date,
    COUNT(*) AS record_count
FROM curated_transactions
WHERE batch_date = '{{ ds }}'
GROUP BY batch_date;

-- Check for late or missing data
SELECT
    COUNT(*) AS missing_records
FROM curated_transactions
WHERE batch_date = '{{ ds }}'
  AND transaction_id IS NULL;

-- Freshness validation
SELECT
    MAX(load_timestamp) AS latest_load_time
FROM curated_transactions
WHERE batch_date = '{{ ds }}';
