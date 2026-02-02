-- AWS Enterprise Data Foundation
-- Batch Output Validation
-- Author: Dharmendra

-- Purpose:
-- Validate row counts and detect partial or failed batch loads
-- This query is intended to run via Amazon Athena

SELECT
    batch_date,
    COUNT(*) AS record_count,
    MIN(load_timestamp) AS min_load_ts,
    MAX(load_timestamp) AS max_load_ts
FROM curated_financial_data
WHERE batch_date = DATE '${run_date}'
GROUP BY batch_date;
