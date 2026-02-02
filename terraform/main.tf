terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -----------------------------
# S3 Buckets (Raw/Curated/Publish)
# -----------------------------
resource "aws_s3_bucket" "raw" {
  bucket = "${var.project_name}-raw"
}

resource "aws_s3_bucket" "curated" {
  bucket = "${var.project_name}-curated"
}

resource "aws_s3_bucket" "publish" {
  bucket = "${var.project_name}-publish"
}

# -----------------------------
# SNS Topic (Batch Alerts)
# -----------------------------
resource "aws_sns_topic" "batch_alerts" {
  name = "${var.project_name}-batch-alerts"
}

# -----------------------------
# Placeholders (Enterprise)
# IAM roles/policies for Glue, Step Functions, Athena
# Glue Catalog / Lake Formation
# Step Functions State Machine
# -----------------------------
