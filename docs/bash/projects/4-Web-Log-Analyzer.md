4. **Web Log Analyzer:**
   - Develop a bash script that analyzes web server log files.
   - The script should parse the log files and extract relevant information such as IP addresses, request methods, response codes, and timestamps.
   - Generate statistics such as the number of requests, unique visitors, top requested pages, and top referrers.
   - Add options to specify the log file path and the output format (e.g., text, CSV).
   - Extend the script to generate visualizations (e.g., pie charts, bar graphs) using tools like Gnuplot or ASCII art.

```bash
#!/bin/bash

# Function to analyze web log file
analyze_web_log() {
    local log_file=$1

    echo "==== Web Log Analysis ===="
    echo "Total Requests: $(wc -l < "$log_file")"
    echo "Unique Visitors: $(awk '{print $1}' "$log_file" | sort | uniq | wc -l)"
    echo "Top Requested Pages:"
    awk '{print $7}' "$log_file" | sort | uniq -c | sort -rn | head -5
    echo "Top Referrers:"
    awk '{print $11}' "$log_file" | sort | uniq -c | sort -rn | head -5
}

# Check if log file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

log_file=$1

analyze_web_log "$log_file"
```