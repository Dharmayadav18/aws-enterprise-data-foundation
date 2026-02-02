"""
AWS Enterprise Data Foundation
Glue Job: Incremental Batch Transform (Skeleton)
Author: Dharmendra

Purpose:
- Read partitioned raw data from S3 (placeholder)
- Apply incremental processing logic (watermark / CDC style)
- Write curated Parquet back to S3 (placeholder)
- Emit basic metrics (row counts, timestamps)
"""

import sys
from datetime import datetime

from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext
from pyspark.sql import functions as F


# --------------------------
# Args (Glue Job Parameters)
# --------------------------
args = getResolvedOptions(
    sys.argv,
    [
        "JOB_NAME",
        "raw_s3_path",
        "curated_s3_path",
        "run_date",
        "watermark_column"
    ]
)

JOB_NAME = args["JOB_NAME"]
RAW_S3_PATH = args["raw_s3_path"]
CURATED_S3_PATH = args["curated_s3_path"]
RUN_DATE = args["run_date"]
WATERMARK_COLUMN = args["watermark_column"]


# --------------------------
# Glue / Spark setup
# --------------------------
sc = SparkContext()
glue_context = GlueContext(sc)
spark = glue_context.spark_session

job = Job(glue_context)
job.init(JOB_NAME, args)

start_ts = datetime.utcnow().isoformat()


def read_raw_incremental(raw_path: str, run_date: str):
    """
    Skeleton read:
    - In real pipelines, you read partition(s): .../dt=YYYY-MM-DD/
    - And/or apply watermark filtering.
    """
    # Example partitioned layout path:
    # s3://bucket/raw/events/dt=2024-10-10/
    partition_path = f"{raw_path}/dt={run_date}"

    df = spark.read.parquet(partition_path)

    # Minimal hygiene for demo
    df = df.withColumn("ingested_at_utc", F.lit(start_ts))
    return df


def transform(df):
    """
    Skeleton transform: replace with business logic
    """
    # Example: standardize column names (demo)
    out = df
    return out


def write_curated(df, curated_path: str, run_date: str):
    """
    Write curated Parquet partitioned by dt.
    """
    (df
     .withColumn("dt", F.lit(run_date))
     .write
     .mode("append")
     .partitionBy("dt")
     .parquet(curated_path))


try:
    raw_df = read_raw_incremental(RAW_S3_PATH, RUN_DATE)

    transformed_df = transform(raw_df)

    # Basic metrics
    row_count = transformed_df.count()
    metrics_df = spark.createDataFrame(
        [(JOB_NAME, RUN_DATE, int(row_count), start_ts)],
        ["job_name", "run_date", "row_count", "start_ts_utc"]
    )

    write_curated(transformed_df, CURATED_S3_PATH, RUN_DATE)

    # Optional: write metrics to curated_path/_metrics/ (skeleton)
    (metrics_df
     .write
     .mode("append")
     .parquet(f"{CURATED_S3_PATH}/_metrics/"))

    job.commit()

except Exception as e:
    # In real Glue jobs you also push failure metrics / SNS, etc.
    print(f"Job failed: {str(e)}")
    raise
