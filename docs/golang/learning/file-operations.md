Certainly! Here are some common file operations using the `os` package and other modules in Go, taking into account that `ioutil` is deprecated:

1. Reading a file:
```go
package main

import (
    "fmt"
    "os"
)

func main() {
    file, err := os.Open("file.txt")
    if err != nil {
        fmt.Println("Error opening file:", err)
        return
    }
    defer file.Close()

    // Read the file content
    content, err := os.ReadFile("file.txt")
    if err != nil {
        fmt.Println("Error reading file:", err)
        return
    }

    fmt.Println(string(content))
}
```

2. Writing to a file:
```go
package main

import (
    "fmt"
    "os"
)

func main() {
    content := []byte("Hello, World!")

    err := os.WriteFile("file.txt", content, 0644)
    if err != nil {
        fmt.Println("Error writing to file:", err)
        return
    }

    fmt.Println("File written successfully.")
}
```

3. Appending to a file:
```go
package main

import (
    "fmt"
    "os"
)

func main() {
    file, err := os.OpenFile("file.txt", os.O_APPEND|os.O_WRONLY, 0644)
    if err != nil {
        fmt.Println("Error opening file:", err)
        return
    }
    defer file.Close()

    content := []byte("Appended content.\n")
    _, err = file.Write(content)
    if err != nil {
        fmt.Println("Error appending to file:", err)
        return
    }

    fmt.Println("Content appended successfully.")
}
```

4. Copying a file:
```go
package main

import (
    "fmt"
    "io"
    "os"
)

func main() {
    sourceFile, err := os.Open("source.txt")
    if err != nil {
        fmt.Println("Error opening source file:", err)
        return
    }
    defer sourceFile.Close()

    destinationFile, err := os.Create("destination.txt")
    if err != nil {
        fmt.Println("Error creating destination file:", err)
        return
    }
    defer destinationFile.Close()

    _, err = io.Copy(destinationFile, sourceFile)
    if err != nil {
        fmt.Println("Error copying file:", err)
        return
    }

    fmt.Println("File copied successfully.")
}
```

5. Deleting a file:
```go
package main

import (
    "fmt"
    "os"
)

func main() {
    err := os.Remove("file.txt")
    if err != nil {
        fmt.Println("Error deleting file:", err)
        return
    }

    fmt.Println("File deleted successfully.")
}
```

These examples demonstrate some common file operations using the `os` package and other modules in Go. The `os` package provides functions for opening, reading, writing, appending, and deleting files, while the `io` package is used for copying files.

Note that error handling is important when working with files to ensure proper execution and graceful handling of any issues that may arise.


## Certainly! Here's an example of working with CSV files in Go using the `encoding/csv` package:

1. Reading from a CSV file:
```go
package main

import (
    "encoding/csv"
    "fmt"
    "os"
)

func main() {
    file, err := os.Open("data.csv")
    if err != nil {
        fmt.Println("Error opening CSV file:", err)
        return
    }
    defer file.Close()

    reader := csv.NewReader(file)
    data, err := reader.ReadAll()
    if err != nil {
        fmt.Println("Error reading CSV data:", err)
        return
    }

    for _, row := range data {
        fmt.Println(row)
    }
}
```

In this example, we open a CSV file named "data.csv" using `os.Open()`. We then create a new CSV reader using `csv.NewReader()` and read all the data from the file using `reader.ReadAll()`. Finally, we iterate over each row of the CSV data and print it.

2. Writing to a CSV file:
```go
package main

import (
    "encoding/csv"
    "fmt"
    "os"
)

func main() {
    data := [][]string{
        {"Name", "Age", "City"},
        {"John", "30", "New York"},
        {"Alice", "25", "London"},
        {"Bob", "35", "Paris"},
    }

    file, err := os.Create("output.csv")
    if err != nil {
        fmt.Println("Error creating CSV file:", err)
        return
    }
    defer file.Close()

    writer := csv.NewWriter(file)
    defer writer.Flush()

    for _, row := range data {
        err := writer.Write(row)
        if err != nil {
            fmt.Println("Error writing to CSV:", err)
            return
        }
    }

    fmt.Println("CSV file created successfully.")
}
```

In this example, we have a slice of string slices called `data` representing the CSV data we want to write. We create a new CSV file named "output.csv" using `os.Create()`. We then create a new CSV writer using `csv.NewWriter()`.

We iterate over each row of the `data` slice and write it to the CSV file using `writer.Write()`. After writing all the rows, we call `writer.Flush()` to ensure that all the data is written to the file.

3. Customizing CSV options:
```go
package main

import (
    "encoding/csv"
    "fmt"
    "os"
)

func main() {
    file, err := os.Open("data.csv")
    if err != nil {
        fmt.Println("Error opening CSV file:", err)
        return
    }
    defer file.Close()

    reader := csv.NewReader(file)
    reader.Comma = ';'  // Set custom delimiter
    reader.Comment = '#'  // Set custom comment character

    data, err := reader.ReadAll()
    if err != nil {
        fmt.Println("Error reading CSV data:", err)
        return
    }

    for _, row := range data {
        fmt.Println(row)
    }
}
```

In this example, we demonstrate how to customize the CSV options. We set the `Comma` field of the CSV reader to `;` to specify a custom delimiter, and we set the `Comment` field to `#` to specify a custom comment character.

These examples cover the basic operations of reading from and writing to CSV files in Go using the `encoding/csv` package. You can further customize the CSV options and handle different scenarios based on your specific requirements.