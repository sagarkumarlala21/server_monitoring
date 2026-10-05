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

    CPU_IDLE=$(top -bn1 | awk -F'[, ]+' '/Cpu\(s\)/ {print $8}')

    CPU_USAGE=$(awk "BEGIN {printf \"%.0f\", 100 - $CPU_IDLE}")

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

# ==============================
# SERVICE CHECK
# ==============================

check_services() {

    echo ""
    echo "------ SERVICE CHECK ------"

    for service in "${SERVICES[@]}"
    do
        if systemctl is-active --quiet "$service"; then
            echo "$service : Running"
        else
            echo "$service : NOT Running"
        fi
    done
}

# ==============================
# DOCKER CHECK
# ==============================

check_docker() {

    echo ""
    echo "------ DOCKER CHECK ------"

    if docker info > /dev/null 2>&1; then
        echo "Docker : Running"

        RUNNING_CONTAINERS=$(docker ps -q | wc -l)

        echo "Running Containers : $RUNNING_CONTAINERS"

    else
        echo "Docker : NOT Running"
    fi
}
check_processes() {

    echo ""
    echo "------ TOP PROCESSES ------"
    #ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6 'to check all the pid ps'
    #ps -eo pid,comm,%cpu,%mem --sort=-%cpu | grep -v "^ *[0-9]* ps " | head -6 #this will show top 5 processes by CPU usage and grep -v "^ *[0-9]* ps "  will more the ps pid form list
     ps -eo pid,comm,%cpu,%mem --sort=-%cpu \
        | grep -vE "COMMAND|ps|server-health-c" \
        | head -10
        #server-health-c is your own monitoring script, so just like ps, we should exclude the health-check script itself from the “Top Processes”
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
check_services
check_docker
check_processes
# echo "CPU Threshold    : $CPU_THRESHOLD%"
# echo "Memory Threshold : $MEMORY_THRESHOLD%"
# echo "Disk Threshold   : $DISK_THRESHOLD%"
# echo "Log File         : $LOG_FILE"
echo ""
echo "======================================"
