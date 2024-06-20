Certainly! Here are a few examples of working with JSON in Go using the `encoding/json` package:

1. Encoding JSON:
```go
package main

import (
    "encoding/json"
    "fmt"
)

type Person struct {
    Name  string `json:"name"`
    Age   int    `json:"age"`
    Email string `json:"email"`
}

func main() {
    person := Person{
        Name:  "John Doe",
        Age:   30,
        Email: "john@example.com",
    }

    jsonData, err := json.Marshal(person)
    if err != nil {
        fmt.Println("Error encoding JSON:", err)
        return
    }

    fmt.Println(string(jsonData))
}
```

In this example, we define a `Person` struct with fields `Name`, `Age`, and `Email`. We create an instance of the `Person` struct and then use `json.Marshal()` to encode it into a JSON byte slice. Finally, we convert the byte slice to a string and print it.

2. Decoding JSON:
```go
package main

import (
    "encoding/json"
    "fmt"
)

type Person struct {
    Name  string `json:"name"`
    Age   int    `json:"age"`
    Email string `json:"email"`
}

func main() {
    jsonData := []byte(`{"name":"John Doe","age":30,"email":"john@example.com"}`)

    var person Person
    err := json.Unmarshal(jsonData, &person)
    if err != nil {
        fmt.Println("Error decoding JSON:", err)
        return
    }

    fmt.Println(person)
}
```

In this example, we have a JSON byte slice `jsonData`. We define a `Person` struct to hold the decoded data. We use `json.Unmarshal()` to decode the JSON data into the `person` struct. Finally, we print the `person` struct.

3. Working with JSON files:
```go
package main

import (
    "encoding/json"
    "fmt"
    "os"
)

type Config struct {
    Host     string `json:"host"`
    Port     int    `json:"port"`
    Username string `json:"username"`
    Password string `json:"password"`
}

func main() {
    file, err := os.Open("config.json")
    if err != nil {
        fmt.Println("Error opening JSON file:", err)
        return
    }
    defer file.Close()

    var config Config
    decoder := json.NewDecoder(file)
    err = decoder.Decode(&config)
    if err != nil {
        fmt.Println("Error decoding JSON:", err)
        return
    }

    fmt.Println(config)
}
```

In this example, we have a JSON file named "config.json". We open the file using `os.Open()` and create a new JSON decoder using `json.NewDecoder()`. We then use `decoder.Decode()` to decode the JSON data from the file into the `config` struct. Finally, we print the `config` struct.

These examples demonstrate the basic operations of encoding and decoding JSON in Go using the `encoding/json` package. You can customize the struct tags to control the field names in the JSON output, handle nested structures, and work with different JSON formats based on your specific requirements.