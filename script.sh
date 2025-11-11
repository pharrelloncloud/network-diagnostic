#!/usr/bin/env bash

#=================================================================
# Network Diagnostic Script
# This script checks the network connectivity and displays
# the current network configuration and logs it.
#=================================================================  
set -euo pipefail

LOG_DIR="./network_logs"
LOG_FILE="$LOG_DIR/network_diagnostic_$(date +'%Y%m%d_%H%M%S').log"

# Creates a log directory if it doesn't exist
if [ ! -d "$LOG_DIR" ]; then
mkdir -p "$LOG_DIR" 
fi


# Function to check and install required packages
check_and_install_installations(){
    local packages=("dnsutils" "net-tools" "traceroute")
    for pkg in "${packages[@]}"; do
        if ! dpkg -s "$pkg" &> /dev/null; then
            echo "Package $pkg is not installed. Installing..."
            sudo apt update && sudo apt install -y "$pkg"
        fi
    done
}
check_and_install_installations

echo "==============================================" | tee -a "$LOG_FILE"
echo " Network Diagnostic Report" | tee -a "$LOG_FILE"
echo "==============================================" | tee -a "$LOG_FILE"
echo "Generated on Date: $(date)" | tee -a "$LOG_FILE"
echo "Saved to: $LOG_FILE" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

echo "[1] IP Configuration:" | tee -a "$LOG_FILE"
ip addr show | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

echo "[2] Routing Table:" | tee -a "$LOG_FILE"
ip route show | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

echo "[3] DNS Resolution Test:(google.com)" | tee -a "$LOG_FILE"
nslookup google.com | tee -a "$LOG_FILE" 2>&1
echo "" | tee -a "$LOG_FILE"

echo "[4] Connectivity Test to google.com (4 packets):" | tee -a "$LOG_FILE"
ping -c 4 google.com | tee -a "$LOG_FILE" 2>&1
echo "" | tee -a "$LOG_FILE"

echo "[5] Active Network Interfaces" | tee -a "$LOG_FILE"
netstat -i | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

echo " Diagnostic Completed. Please check the log file for details: $LOG_FILE" | tee -a "$LOG_FILE"