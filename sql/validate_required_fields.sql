-- AWS Enterprise Data Foundation
-- Validation: Required Fields / Null Checks
-- Author: Dharmendra

SELECT
  COUNT(*) AS bad_rows
FROM curated_layer.sample_table
WHERE run_date = '{{ ds }}'
  AND (
    primary_id IS NULL
    OR event_timestamp IS NULL
  );

-- Expected:
-- bad_rows = 0
-- Used as a gate before publishing to analytics/reporting tables
