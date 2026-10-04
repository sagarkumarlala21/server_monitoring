#!/bin/bash

# ==============================
# Server Health Check
# ==============================

# Load configuration
source "$(dirname "$0")/config.sh"

echo "======================================"
echo "       SERVER HEALTH CHECK"
echo "======================================"

echo "Hostname : $(hostname)"
echo "Uptime   : $(uptime -p)"
echo "CPU Threshold    : $CPU_THRESHOLD%"
echo "Memory Threshold : $MEMORY_THRESHOLD%"
echo "Disk Threshold   : $DISK_THRESHOLD%"
echo "Log File         : $LOG_FILE"

echo "======================================"
