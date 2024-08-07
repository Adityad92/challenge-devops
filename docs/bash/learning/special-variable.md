In shell scripting, there are several special variables (also known as shell parameters) that have specific meanings and behaviors. These special variables are often used in scripts to handle arguments, statuses, and other context-specific information. Here is a list of some commonly used special variables:

### Special Shell Variables

1. **`$#`**
   - Represents the number of positional parameters (arguments) passed to the script or function.
   - Example: If a script is called with three arguments (`./script.sh arg1 arg2 arg3`), `$#` will be `3`.

2. **`$0`**
   - Contains the name of the script or the command being executed.
   - Example: If a script is called as `./script.sh`, `$0` will be `./script.sh`.

3. **`$1, $2, ... $N`**
   - Represent the positional parameters (arguments) passed to the script or function.
   - Example: If a script is called with arguments (`./script.sh arg1 arg2`), `$1` will be `arg1` and `$2` will be `arg2`.

4. **`$*`**
   - Represents all the positional parameters as a single word.
   - Example: If a script is called with arguments (`./script.sh arg1 arg2`), `$*` will be `arg1 arg2`.

5. **`$@`**
   - Represents all the positional parameters as separate words.
   - Example: If a script is called with arguments (`./script.sh arg1 arg2`), `$@` will be `arg1` `arg2`.

6. **`$?`**
   - Contains the exit status of the last command executed.
   - Example: After a command `ls` is executed, `$?` will contain the exit status of `ls`.

7. **`$$`**
   - Contains the process ID (PID) of the shell executing the script.
   - Example: If a script is running, `$$` will provide the PID of the shell.

8. **`$!`**
   - Contains the process ID of the last background command executed.
   - Example: If a command is run in the background (`sleep 100 &`), `$!` will contain the PID of the `sleep` command.

9. **`$-`**
   - Contains the current options set for the shell.
   - Example: If the shell has options like `-x` (for debugging), `$-` will include `x`.

10. **`$_`**
    - Contains the last argument of the previous command.
    - Example: If a command `echo foo` is executed, `$_` will contain `foo`.

### Usage Examples

Here's a small script to demonstrate some of these variables:

```sh
#!/bin/bash

echo "Script name: $0"
echo "Number of arguments: $#"
echo "All arguments as a single word: $*"
echo "All arguments as separate words: $@"
echo "First argument: $1"
echo "Second argument: $2"
echo "Exit status of the last command: $?"
echo "Process ID of the shell: $$"
echo "Process ID of the last background command: $!"

# Run a background command
sleep 10 &
echo "Process ID of the sleep command: $!"

echo "Last argument of the previous command: $_"
```

If you run this script with some arguments, for example:

```sh
./script.sh arg1 arg2
```

You would see output corresponding to the special variables based on the provided arguments and the script’s execution context.


### This is a Bash shell parameter expansion used to extract a substring from the variable VELA_BUILD_TAG. Let's break it down:

${VELA_BUILD_TAG}: This refers to the variable VELA_BUILD_TAG. It's likely this variable holds a string representing a build tag, potentially including a version prefix like "v".
##: This is a Bash operator used for removing a prefix pattern. It works from right to left, removing the longest matching pattern from the beginning of the variable's value.
v: This is the pattern being removed. In this case, it's the letter "v".
In essence, the expression ${VELA_BUILD_TAG##v} removes the shortest prefix "v" from the value of VELA_BUILD_TAG.

Example:

If VELA_BUILD_TAG is set to "v1.2.3", then:


${VELA_BUILD_TAG##v} 
will evaluate to "1.2.3".

Purpose:

This parameter expansion is commonly used to extract the actual version number from a build tag that includes a version prefix. It allows you to work with just the version information without the leading "v".