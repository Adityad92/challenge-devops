2. **System Monitor:**
   - Develop a bash script that monitors system resources and generates a report.
   - The script should retrieve information such as CPU usage, memory usage, disk space, and network statistics.
   - Display the information in a formatted manner, including graphs or charts using ASCII art.
   - Add options to specify the monitoring interval and the output format (e.g., text, HTML).
   - Extend the script to send email alerts if certain thresholds are exceeded.



```bash
#!/bin/bash

# Function to display system information
display_system_info() {
    echo "==== System Information ===="
    echo "CPU Usage: $(top -bn1 | grep load | awk '{printf "%.2f%%\n", $(NF-2)}')"
    echo "Memory Usage: $(free -m | awk 'NR==2{printf "%.2f%%\n", $3*100/$2}')"
    echo "Disk Space: $(df -h | awk '$NF=="/"{printf "%s/%s (%s)\n", $3, $2, $5}')"
    echo "Network Statistics:"
    echo "  - IP Address: $(hostname -I)"
    echo "  - Bytes Received: $(cat /sys/class/net/*/statistics/rx_bytes | paste -sd+ | bc)"
    echo "  - Bytes Transmitted: $(cat /sys/class/net/*/statistics/tx_bytes | paste -sd+ | bc)"
}

# Check if monitoring interval is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <monitoring_interval_in_seconds>"
    exit 1
fi

monitoring_interval=$1

# Continuously display system information
while true; do
    clear
    display_system_info
    sleep "$monitoring_interval"
done
```