In Bash, `-z`, `-f`, and `-d` are conditional expressions used in `if` statements and `test` commands to evaluate certain conditions. Here's a brief explanation of each:

1. `-z`: Tests if a string is empty (has zero length).
   Example: `if [ -z "$variable" ]; then echo "Variable is empty"; fi`

2. `-f`: Tests if a file exists and is a regular file.
   Example: `if [ -f "file.txt" ]; then echo "file.txt exists"; fi`

3. `-d`: Tests if a directory exists.
   Example: `if [ -d "directory" ]; then echo "directory exists"; fi`

These are just a few examples of the many conditional expressions available in Bash. Here's a list of some commonly used conditional expressions:

- `-e`: Tests if a file exists (regardless of its type).
- `-s`: Tests if a file exists and has a size greater than zero.
- `-r`, `-w`, `-x`: Tests if a file has read, write, or execute permissions, respectively.
- `-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge`: Arithmetic comparisons for integers.
- `=`, `!=`, `<`, `>`: String comparisons.
- `&&`, `||`: Logical AND and OR operators.

For the official documentation and a complete list of conditional expressions, you can refer to the following links:

1. Bash Manual - Conditional Constructs: https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html

2. Bash Reference Manual - Bash Conditional Expressions: https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html

These resources provide detailed information about the various conditional expressions, their usage, and additional examples.