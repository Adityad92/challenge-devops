#  1. https://pkg.go.dev/github.com/fatih/color#pkg-overview

// you can use github.com/fatih/color package as well
```golang
	color.Green("Bright green color.")
```


# 2. To achieve the same functionality in Go, you can use the `fmt` package and ANSI escape codes for color formatting. Here's the equivalent code in Go:

```go
package main

import "fmt"

func color(colorName string) {
    switch colorName {
    case "red":
        fmt.Print("\033[31m")
    case "green":
        fmt.Print("\033[32m")
    case "yellow":
        fmt.Print("\033[33m")
    default:
        fmt.Print("\033[0m")
    }
}

func main() {
    color("green")
    fmt.Println("hello")
    color("reset")
}
```

Explanation:
- The `color` function takes a `colorName` string parameter and uses a `switch` statement to determine the corresponding ANSI escape code for the color.
- The ANSI escape codes are used to set the color of the text in the terminal:
  - `\033[31m` sets the color to red.
  - `\033[32m` sets the color to green.
  - `\033[33m` sets the color to yellow.
  - `\033[0m` resets the color to the default.
- In the `main` function, we call the `color` function with the desired color name before printing the text.
- After printing the colored text, we call `color("reset")` to reset the color to the default.

Note: The ANSI escape codes used in this code are widely supported by most modern terminals. However, if you're using an older terminal or a terminal that doesn't support ANSI escape codes, the colors may not be displayed correctly.

When you run this Go code, it will output "hello" in green color in the terminal.


## The ANSI escape codes used for coloring the text in the terminal are part of the ANSI (American National Standards Institute) standard. These codes are not specific to Go, but rather a widely adopted standard for controlling text formatting, colors, and other attributes in command-line interfaces.

While there isn't a single official documentation for ANSI escape codes, you can find information about them from various sources. Here are a few links that provide detailed explanations and references for ANSI escape codes:

1. Wikipedia - ANSI escape code: 
   https://en.wikipedia.org/wiki/ANSI_escape_code

2. ASCII Table - ANSI Escape sequences:
   https://ascii-table.com/ansi-escape-sequences.php

3. Bash Hackers Wiki - ANSI Escape Sequences:
   https://wiki.bash-hackers.org/scripting/terminalcodes

4. Xterm Control Sequences:
   https://invisible-island.net/xterm/ctlseqs/ctlseqs.html

5. ANSI Escape Code - Colored Text:
   https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

These resources provide detailed information about ANSI escape codes, including the codes for different colors, text styles (bold, italic, underline), cursor movement, and more.

Keep in mind that while ANSI escape codes are widely supported, their interpretation may vary slightly across different terminals and operating systems. It's always a good idea to test your code in the target environment to ensure the desired formatting is displayed correctly.