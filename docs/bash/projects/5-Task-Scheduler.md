5. **Task Scheduler:**
   - Create a bash script that acts as a task scheduler, allowing users to schedule and manage tasks.
   - The script should allow users to add, remove, and list tasks.
   - Each task should have a name, command to execute, and schedule (e.g., daily, weekly, specific time).
   - Implement logging to keep track of task execution and any errors encountered.
   - Extend the script to support task dependencies and email notifications upon task completion or failure.

```bash
#!/bin/bash

# Function to add a new task
add_task() {
    echo "Enter task name:"
    read task_name
    echo "Enter command to execute:"
    read task_command
    echo "Enter schedule (daily/weekly/specific time):"
    read task_schedule

    echo "$task_name:$task_command:$task_schedule" >> tasks.txt
    echo "Task added successfully."
}

# Function to remove a task
remove_task() {
    echo "Enter task name to remove:"
    read task_name

    sed -i "/^$task_name:/d" tasks.txt
    echo "Task removed successfully."
}

# Function to list all tasks
list_tasks() {
    echo "==== Scheduled Tasks ===="
    cat tasks.txt
}

# Function to run scheduled tasks
run_tasks() {
    while true; do
        current_time=$(date +%H:%M)
        current_day=$(date +%u)

        while IFS=: read -r task_name task_command task_schedule; do
            case $task_schedule in
                daily)
                    eval "$task_command"
                    ;;
                weekly)
                    if [ "$current_day" -eq 1 ]; then
                        eval "$task_command"
                    fi
                    ;;
                *)
                    if [ "$current_time" == "$task_schedule" ]; then
                        eval "$task_command"
                    fi
                    ;;
            esac
        done < tasks.txt

        sleep 60
    done
}

# Main script
while true; do
    echo "==== Task Scheduler ===="
    echo "1. Add Task"
    echo "2. Remove Task"
    echo "3. List Tasks"
    echo "4. Run Tasks"
    echo "5. Exit"
    echo "Enter your choice (1-5):"
    read choice

    case $choice in
        1) add_task ;;
        2) remove_task ;;
        3) list_tasks ;;
        4) run_tasks ;;
        5) exit ;;
        *) echo "Invalid choice. Please try again." ;;
    esac

    echo
done
```