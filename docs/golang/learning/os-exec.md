The `os/exec` package in Go is used to run external commands. It provides a way to run system commands, capture their output, and control their input. By applying the 80-20 principle, we can focus on the most critical aspects of `os/exec` that will cover the majority of use cases.  
   
1. **Running External Commands**:  
   - `exec.Command(name string, arg ...string) *Cmd`: This is the most important function, which creates a new `Cmd` object to represent an external command. The `name` is the command to run, and `arg` are the arguments to pass to it.  
   
2. **Command Execution**:  
   - `cmd.Run() error`: Executes the command, waits for it to finish, and returns any error that occurs.  
   - `cmd.Start() error`: Starts the command but does not wait for it to complete. You need to call `cmd.Wait()` to wait for the command to finish and release associated resources.  
   - `cmd.Output() ([]byte, error)`: Runs the command and returns its standard output. It's useful when you're only interested in the output of the command.  
   - `cmd.CombinedOutput() ([]byte, error)`: Runs the command and returns its combined standard output and standard error.  
   
3. **Standard I/O**:  
   - `cmd.Stdin`, `cmd.Stdout`, `cmd.Stderr`: These fields can be set to specify the command's standard input, output, and error streams. You can use them to redirect I/O to files, buffers, or other processes.  
   
4. **Environment and Working Directory**:  
   - `cmd.Env []string`: If non-nil, it replaces the system environment for the command.  
   - `cmd.Dir string`: Sets the command's working directory.  
   
**Scenarios**:  
   
- **Running Shell Commands**: If you need to invoke shell commands like `ls`, `grep`, or `mkdir`, you would use `exec.Command` with `cmd.Run` or `cmd.Output` to execute the command and optionally capture its output.  
   
```go  
cmd := exec.Command("ls", "-l", "/some/directory")  
output, err := cmd.Output()  
if err != nil {  
    log.Fatal(err)  
}  
fmt.Println(string(output))  
```  
   
- **Streaming Output**: When running commands that produce continuous output (like `tail -f`), you can set `cmd.Stdout` to an os.File or a buffer to read the stream.  
   
```go  
cmd := exec.Command("tail", "-f", "/var/log/syslog")  
cmd.Stdout = os.Stdout // Redirect output to the standard output of the Go process  
err := cmd.Start()  
if err != nil {  
    log.Fatal(err)  
}  
err = cmd.Wait() // Wait for the command to finish  
```  
   
- **Pipelines and Redirection**: For constructing pipelines or redirecting output from one command to another, use the standard I/O fields.  
   
```go  
grepCmd := exec.Command("grep", "error")  
catCmd := exec.Command("cat", "/var/log/syslog")  
   
// Create a pipe between cat and grep  
pipe, _ := catCmd.StdoutPipe()  
grepCmd.Stdin = pipe  
   
// Start the 'grep' before 'cat' to avoid deadlock  
grepCmd.Start()  
catCmd.Run()  
pipe.Close()  
   
output, _ := ioutil.ReadAll(grepCmd.Stdout)  
grepCmd.Wait()  
```  
   
- **Background Processes**: If you're running a background task, such as starting a local server, use `cmd.Start` without immediately waiting for it to finish.  
   
```go  
cmd := exec.Command("some_server")  
err := cmd.Start()  
if err != nil {  
    log.Fatal(err)  
}  
   
// Do other work or keep the application running  
// ...  
   
// Later, you can wait for the command to finish  
err = cmd.Wait()  
if err != nil {  
    log.Fatal(err)  
}  
```  
   
- **Custom Environment Variables**: In scenarios where you need to run a command with a specific set of environment variables, you can use the `cmd.Env` field to set them before running the command. This is useful when dealing with tools that require environment configuration or when isolating the command's environment from the parent process.  
   
```go  
cmd := exec.Command("some_command")  
cmd.Env = append(os.Environ(), "CUSTOM_VAR=VALUE")  
output, err := cmd.Output()  
if err != nil {  
    log.Fatal(err)  
}  
fmt.Println(string(output))  
```  
   
- **Running Commands in a Specific Directory**: Sometimes, you need to run a command within a specific directory context. You can set `cmd.Dir` to change the working directory of the command.  
   
```go  
cmd := exec.Command("git", "status")  
cmd.Dir = "/path/to/git/repo"  
output, err := cmd.Output()  
if err != nil {  
    log.Fatal(err)  
}  
fmt.Println(string(output))  
```  
   
- **Interacting with Command Input**: If the external command requires input from the standard input, you can write to `cmd.Stdin`. This is common when you're dealing with commands that prompt for user input or read from the terminal.  
   
```go  
cmd := exec.Command("passwd", "username")  
stdin, err := cmd.StdinPipe()  
if err != nil {  
    log.Fatal(err)  
}  
   
// Write the desired input to the command's stdin  
go func() {  
    defer stdin.Close()  
    io.WriteString(stdin, "newpassword\nnewpassword\n")  
}()  
   
err = cmd.Run()  
if err != nil {  
    log.Fatal(err)  
}  
```  
   
- **Error Handling**: When running a command, it's important to handle errors properly. The command might fail to start, or it might run and return a non-zero exit status, indicating an error. Always check the error returned from `Run`, `Start`, `Output`, or `CombinedOutput`.  
   
```go  
cmd := exec.Command("some_command", "arg1", "arg2")  
err := cmd.Run()  
if err != nil {  
    if exitErr, ok := err.(*exec.ExitError); ok {  
        // The command has run but returned a non-zero status  
        fmt.Println("Command failed with:", string(exitErr.Stderr))  
    } else {  
        // There was an issue starting the command  
        log.Fatal(err)  
    }  
}  
```  
   
These scenarios cover the majority of use cases you'll encounter when working with external commands in Go. The `os/exec` package is powerful and provides the tools needed to interact with system commands and subprocesses effectively. Remember that running external commands can introduce security risks, especially when dealing with untrusted input, so always be cautious and validate or sanitize inputs where necessary.