# https://www.squash.io/adding-color-to-bash-scripts-in-linux/
# https://manned.org/tput.1
# # Set color variables
# RED=$(tput setaf 1)
# GREEN=$(tput setaf 2)
# YELLOW=$(tput setaf 3)
# RESET=$(tput sgr0)

# tput setaf 2
# echo "hello"

```bash
#!/bin/bash
color() {
    if [ $1 == "red" ]; then
        tput setaf 1
    elif [ $1 == "green" ]; then
        tput setaf 2
    elif [ $1 == "yellow" ]; then
        tput setaf 3
    else
        tput sgr0
    fi
}

color green
echo "hello"
```