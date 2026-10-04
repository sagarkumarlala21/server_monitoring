#!/bin/bash

# ==============================
# Server Health Monitor Config
# ==============================

# Health thresholds (%)
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Services to monitor
SERVICES=("ssh" "docker")

# Project directories
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOG_DIR="$BASE_DIR/logs"
REPORT_DIR="$BASE_DIR/reports"

LOG_FILE="$LOG_DIR/server_health.log"
