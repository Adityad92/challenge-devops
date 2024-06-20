**3. Simple Monitoring Script:**

* **Project:** Create a script that monitors a system metric (e.g., CPU usage, disk space) and sends alerts if it exceeds a threshold.
* **Learning:**  This project covers working with system metrics, setting up timers, and sending notifications (e.g., email, Slack).



Certainly! Here's an example of a Go script that monitors CPU usage and sends alerts if it exceeds a specified threshold:

```go
package main

import (
    "fmt"
    "log"
    "os"
    "time"

    "github.com/shirou/gopsutil/cpu"
)

func main() {
    // Set the CPU usage threshold (in percentage)
    threshold := 80.0

    // Set the monitoring interval (in seconds)
    interval := 5

    // Set the email configuration
    from := "sender@example.com"
    to := "recipient@example.com"
    subject := "High CPU Usage Alert"
    smtpServer := "smtp.example.com"
    smtpPort := 587
    smtpUsername := "your_username"
    smtpPassword := "your_password"

    for {
        // Get the current CPU usage
        cpuPercent, err := cpu.Percent(0, false)
        if err != nil {
            log.Fatal(err)
        }

        // Check if the CPU usage exceeds the threshold
        if cpuPercent[0] > threshold {
            // Send an email alert
            message := fmt.Sprintf("CPU usage is %.2f%%. Threshold exceeded!", cpuPercent[0])
            err := sendEmail(from, to, subject, message, smtpServer, smtpPort, smtpUsername, smtpPassword)
            if err != nil {
                log.Println("Failed to send email alert:", err)
            } else {
                log.Println("Email alert sent successfully.")
            }
        }

        // Wait for the specified interval before checking again
        time.Sleep(time.Duration(interval) * time.Second)
    }
}

func sendEmail(from, to, subject, message, smtpServer string, smtpPort int, smtpUsername, smtpPassword string) error {
    // Implement the email sending logic using the provided SMTP configuration
    // You can use libraries like "net/smtp" or third-party packages for sending emails
    // For simplicity, this example doesn't include the actual email sending code
    fmt.Printf("Sending email from %s to %s with subject: %s\n", from, to, subject)
    fmt.Printf("Message: %s\n", message)
    return nil
}
```

In this example:

1. We set the CPU usage threshold (in percentage) and the monitoring interval (in seconds) as variables.

2. We configure the email settings, including the sender and recipient email addresses, subject, SMTP server details, and authentication credentials.

3. We start an infinite loop that continuously monitors the CPU usage.

4. Inside the loop, we use the `cpu.Percent` function from the `gopsutil` package to get the current CPU usage percentage.

5. We check if the CPU usage exceeds the specified threshold.

6. If the threshold is exceeded, we send an email alert using the `sendEmail` function. The email includes the current CPU usage percentage and a message indicating that the threshold has been exceeded.

7. If the email is sent successfully, we log a success message. If there's an error sending the email, we log an error message.

8. After each iteration, we wait for the specified interval using `time.Sleep` before checking the CPU usage again.

9. The `sendEmail` function is a placeholder for the actual email sending logic. You'll need to implement the email sending functionality using libraries like `net/smtp` or third-party packages based on your requirements.

Note: Make sure to install the `gopsutil` package by running `go get github.com/shirou/gopsutil` before running the script.

Remember to replace the email configuration values with your own SMTP server details and authentication credentials.

This script provides a basic framework for monitoring CPU usage and sending alerts when a threshold is exceeded. You can extend it to monitor other system metrics, such as disk space or memory usage, by utilizing the appropriate functions from the `gopsutil` package or other system monitoring libraries.