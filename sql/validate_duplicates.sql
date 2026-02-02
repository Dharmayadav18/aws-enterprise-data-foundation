-- AWS Enterprise Data Foundation
-- Validation: Duplicate Detection
-- Author: Dharmendra

SELECT
  primary_id,
  COUNT(*) AS dup_count
FROM curated_layer.sample_table
WHERE run_date = '{{ ds }}'
GROUP BY primary_id
HAVING COUNT(*) > 1;

-- Expected:
-- No rows returned
-- Prevents duplicate records from reaching reporting layer
