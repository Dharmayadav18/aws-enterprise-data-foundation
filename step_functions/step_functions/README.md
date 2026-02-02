# Step Functions - Batch Orchestrator (Skeleton)

Author: Dharmendra

This folder contains an AWS Step Functions state machine definition used to orchestrate an enterprise batch workflow:

- Run AWS Glue job (incremental batch transform)
- Run Athena validation query (DQ gate)
- Publish gate (only if validation passes)
- SNS notifications for success/failure

This is a skeleton designed to demonstrate structure and production-style control flow.
