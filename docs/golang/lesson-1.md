## Variable address passing

In this example, we have two variables, name and age, that we want to read from the terminal. Here's how it works:

We use the fmt.Print() function to prompt the user to enter their name.
We then use fmt.Scan(&name) to read the user's input and store it in the name variable. The & symbol is used to pass the address of the variable to the Scan() function.
We check for any errors that may have occurred during the input reading process using the returned error value.
We repeat the same process for the age variable, using fmt.Scan(&age) to read the user's input.
Finally, we use fmt.Printf() to print the user's name and age.
Alternatively, you can use the fmt.Scanln() function, which reads input until a newline character is encountered:


fmt.Print("Enter your name and age: ")
_, err := fmt.Scanln(&name, &age)
if err != nil {
    fmt.Println("Error:", err)
    return
}
In this case, the user can enter their name and age on the same line, separated by a space, and the input will be read correctly.

Remember that the Scan() and Scanln() functions return the number of successfully scanned items and an error value, so it's important to check for any errors that may have occurred during the input reading process.


## Certainly! Let's break down the `fmt.Scan()` function:

1. `fmt.Scan(a ...any) (n int, err error)`

   - This is the function signature of `fmt.Scan()`.
   - `a ...any` is a variadic parameter, which means it can accept any number of arguments of any type.
   - The function returns two values:
     - `n int`: The number of successfully scanned items.
     - `err error`: An error value, if any, that occurred during the scanning process.

2. `fmt.Scan(&name, &age)`

   - In this example, we're passing two variables, `name` and `age`, to the `Scan()` function.
   - The `&` symbol is used to pass the address of the variables, so that the `Scan()` function can modify their values directly.
   - The `Scan()` function will read the user's input and store the values in the `name` and `age` variables.

3. `_, err := fmt.Scan(&name, &age)`

   - Here, we're using the short variable declaration syntax (`:=`) to declare two variables: `_` and `err`.
   - The `_` is an unnamed variable, which is used to discard the first return value (the number of successfully scanned items).
   - The `err` variable is used to store the error value returned by the `Scan()` function.

4. `if err != nil { ... }`

   - After calling `fmt.Scan()`, we check if an error occurred during the scanning process.
   - If `err` is not `nil`, it means an error occurred, and we can handle it accordingly (e.g., print an error message, return from the function, etc.).

In summary, the `fmt.Scan()` function is used to read user input from the terminal and store the values in the provided variables. It returns the number of successfully scanned items and an error value, which you should always check to ensure that the input was read correctly.