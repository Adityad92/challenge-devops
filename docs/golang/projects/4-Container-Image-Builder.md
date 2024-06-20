**4. Container Image Builder:**

* **Project:** Build a tool that creates Docker images for your application. This tool can:
    * Take a directory containing your application code and dependencies as input.
    * Create a Dockerfile based on a base image.
    * Build a container image and push it to a registry.
* **Learning:**  You'll learn about Docker and containerization, working with Dockerfiles, and automating container image creation.


Certainly! Let's build a tool in Go that creates Docker images for your application. Here's an example implementation:

```go
package main

import (
    "fmt"
    "io/ioutil"
    "log"
    "os"
    "os/exec"
    "path/filepath"
)

func main() {
    // Check if the required arguments are provided
    if len(os.Args) < 4 {
        fmt.Println("Usage: go run main.go <app-directory> <base-image> <image-name>")
        os.Exit(1)
    }

    // Get the command-line arguments
    appDir := os.Args[1]
    baseImage := os.Args[2]
    imageName := os.Args[3]

    // Create a temporary directory for the Dockerfile
    tempDir, err := ioutil.TempDir("", "docker-build")
    if err != nil {
        log.Fatal(err)
    }
    defer os.RemoveAll(tempDir)

    // Create the Dockerfile content
    dockerfile := fmt.Sprintf(`
FROM %s
WORKDIR /app
COPY . .
RUN go build -o main .
CMD ["./main"]
`, baseImage)

    // Write the Dockerfile to the temporary directory
    dockerfilePath := filepath.Join(tempDir, "Dockerfile")
    err = ioutil.WriteFile(dockerfilePath, []byte(dockerfile), 0644)
    if err != nil {
        log.Fatal(err)
    }

    // Copy the application code and dependencies to the temporary directory
    err = copyDirectory(appDir, tempDir)
    if err != nil {
        log.Fatal(err)
    }

    // Build the Docker image
    buildCmd := exec.Command("docker", "build", "-t", imageName, tempDir)
    buildCmd.Stdout = os.Stdout
    buildCmd.Stderr = os.Stderr
    err = buildCmd.Run()
    if err != nil {
        log.Fatal(err)
    }

    fmt.Printf("Docker image '%s' built successfully.\n", imageName)

    // Push the Docker image to a registry (optional)
    pushCmd := exec.Command("docker", "push", imageName)
    pushCmd.Stdout = os.Stdout
    pushCmd.Stderr = os.Stderr
    err = pushCmd.Run()
    if err != nil {
        log.Fatal(err)
    }

    fmt.Printf("Docker image '%s' pushed to the registry.\n", imageName)
}

func copyDirectory(src, dst string) error {
    // Get the list of files and directories in the source directory
    entries, err := ioutil.ReadDir(src)
    if err != nil {
        return err
    }

    // Create the destination directory if it doesn't exist
    err = os.MkdirAll(dst, 0755)
    if err != nil {
        return err
    }

    // Copy each file and directory recursively
    for _, entry := range entries {
        srcPath := filepath.Join(src, entry.Name())
        dstPath := filepath.Join(dst, entry.Name())

        if entry.IsDir() {
            err = copyDirectory(srcPath, dstPath)
            if err != nil {
                return err
            }
        } else {
            err = copyFile(srcPath, dstPath)
            if err != nil {
                return err
            }
        }
    }

    return nil
}

func copyFile(src, dst string) error {
    // Read the source file
    data, err := ioutil.ReadFile(src)
    if err != nil {
        return err
    }

    // Write the data to the destination file
    err = ioutil.WriteFile(dst, data, 0644)
    if err != nil {
        return err
    }

    return nil
}
```

To use this tool:

1. Save the code in a file named `main.go`.

2. Open a terminal and navigate to the directory containing `main.go`.

3. Run the following command:

   ```
   go run main.go <app-directory> <base-image> <image-name>
   ```

   Replace `<app-directory>` with the path to the directory containing your application code and dependencies, `<base-image>` with the desired base image (e.g., `golang:latest`), and `<image-name>` with the desired name for your Docker image (e.g., `myapp:v1`).

Here's how the tool works:

1. It checks if the required command-line arguments are provided. If not, it displays the usage instructions and exits.

2. It creates a temporary directory to store the generated Dockerfile and the copied application code.

3. It generates the Dockerfile content based on the provided base image. The Dockerfile sets the working directory to `/app`, copies the application code and dependencies, builds the Go application, and sets the default command to run the built executable.

4. It writes the generated Dockerfile to the temporary directory.

5. It copies the application code and dependencies from the specified `<app-directory>` to the temporary directory using the `copyDirectory` function.

6. It executes the `docker build` command to build the Docker image using the generated Dockerfile and the copied application code. The image is tagged with the provided `<image-name>`.

7. If the build is successful, it displays a success message.

8. Optionally, it executes the `docker push` command to push the built Docker image to a registry. Make sure you are logged in to the registry before running the tool.

9. If the push is successful, it displays a success message.

The `copyDirectory` function recursively copies all files and directories from the source directory to the destination directory. It uses the `copyFile` function to copy individual files.

Note: Make sure you have Docker installed and running on your machine before running this tool.

This tool provides a basic framework for creating Docker images for your Go application. You can extend and customize it based on your specific requirements, such as adding more configuration options, handling different base images, or integrating with CI/CD pipelines.

Remember to handle errors appropriately and provide meaningful error messages to the user.