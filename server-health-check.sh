#!/bin/bash

# ==============================
# Server Health Check
# ===============================

# Load configuration
source "$(dirname "$0")/config.sh"

# ==============================
# CPU CHECK
# ==============================

check_cpu() {

    CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')

    CPU_USAGE=${CPU_USAGE%.*}

    echo "CPU Usage : ${CPU_USAGE}%"

    if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
        echo "CPU Status: WARNING"
    else
        echo "CPU Status: OK"
    fi
}

# ==============================
# MEMORY CHECK
# ==============================

check_memory() {

    MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')

    echo "Memory Usage : ${MEMORY_USAGE}%"

    if [ "$MEMORY_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
        echo "Memory Status: WARNING"
    else
        echo "Memory Status: OK"
    fi
}

# ==============================
# DISK CHECK
# ==============================

check_disk() {

    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

    echo "Disk Usage : ${DISK_USAGE}%"

    if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
        echo "Disk Status: WARNING"
    else
        echo "Disk Status: OK"
    fi
}

#MAIN  line to call the functions


echo "======================================"
echo "       SERVER HEALTH CHECK"
echo "======================================"



echo "Hostname : $(hostname)"
echo "Uptime   : $(uptime -p)"

echo ""
echo "------ SYSTEM RESOURCE CHECK ------"

check_cpu
check_memory
check_disk

# echo "CPU Threshold    : $CPU_THRESHOLD%"
# echo "Memory Threshold : $MEMORY_THRESHOLD%"
# echo "Disk Threshold   : $DISK_THRESHOLD%"
# echo "Log File         : $LOG_FILE"
echo ""
echo "======================================"
