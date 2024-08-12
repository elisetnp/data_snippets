#!/bin/bash

# This script tests all Airflow connections by iterating over each connection ID
# and invoking the `airflow connections test` command for each.

for conn_id in $(airflow connections list --output json | grep -oP '"conn_id": *"\K[^"]+'); do
  echo "Testing connection: $conn_id"
  airflow connections test "$conn_id"
done
