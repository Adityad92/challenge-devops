**2. Web Server with Basic API:**

* **Project:** Build a simple web server with a basic REST API that:
    * Serves static content (HTML, CSS, JavaScript)
    * Exposes endpoints for simple operations (e.g., returning data, performing calculations)
* **Learning:**  You'll learn how to work with web frameworks (e.g., Gin, Echo), handle HTTP requests and responses, and create basic APIs.


Certainly! Let's build a simple web server with a basic REST API in Go. Here's an example:

```go
package main

import (
    "encoding/json"
    "fmt"
    "log"
    "net/http"
    "strconv"
)

type Person struct {
    ID   int    `json:"id"`
    Name string `json:"name"`
    Age  int    `json:"age"`
}

var people []Person

func main() {

	// // Populate the people slice with some initial data
	// people = []Person{
	// 	{ID: 1, Name: "John Doe", Age: 30},
	// 	{ID: 2, Name: "Jane Smith", Age: 25},
	// 	{ID: 3, Name: "Bob Johnson", Age: 40},
	// }

    // Serve static files from the "static" directory
    http.Handle("/", http.FileServer(http.Dir("static")))

    // API endpoints
    http.HandleFunc("/api/people", getPeople)
    http.HandleFunc("/api/people/", getPersonByID)
    http.HandleFunc("/api/calculate", calculate)

    fmt.Println("Server is running on http://localhost:8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

func getPeople(w http.ResponseWriter, r *http.Request) {
    json.NewEncoder(w).Encode(people)
}

func getPersonByID(w http.ResponseWriter, r *http.Request) {
    id, err := strconv.Atoi(r.URL.Path[len("/api/people/"):])
    if err != nil {
        http.Error(w, "Invalid ID", http.StatusBadRequest)
        return
    }

    for _, person := range people {
        if person.ID == id {
            json.NewEncoder(w).Encode(person)
            return
        }
    }

    http.Error(w, "Person not found", http.StatusNotFound)
}

func calculate(w http.ResponseWriter, r *http.Request) {
    num1, err := strconv.Atoi(r.URL.Query().Get("num1"))
    if err != nil {
        http.Error(w, "Invalid number", http.StatusBadRequest)
        return
    }

    num2, err := strconv.Atoi(r.URL.Query().Get("num2"))
    if err != nil {
        http.Error(w, "Invalid number", http.StatusBadRequest)
        return
    }

    result := num1 + num2
    fmt.Fprintf(w, "Result: %d", result)
}
```

Let's go through the code:

1. We define a `Person` struct to represent a person with an ID, name, and age.

2. In the `main` function, we set up the server and define the routes:
   - We use `http.Handle("/", http.FileServer(http.Dir("static")))` to serve static files from the "static" directory.
   - We define API endpoints using `http.HandleFunc` for getting all people, getting a person by ID, and performing a calculation.

3. The `getPeople` function is an API endpoint that returns all the people as JSON.

4. The `getPersonByID` function is an API endpoint that retrieves a person by their ID. It extracts the ID from the URL path, searches for the person in the `people` slice, and returns the person as JSON if found. If the person is not found, it returns a "Person not found" error with a 404 status code.

5. The `calculate` function is an API endpoint that performs a simple calculation. It retrieves two numbers from the URL query parameters, adds them together, and returns the result.

To run this code:

1. Create a directory named "static" in the same directory as your Go file.
2. Place your static files (HTML, CSS, JavaScript) inside the "static" directory.
3. Run the Go file using the command: `go run main.go`.
4. Open a web browser and visit `http://localhost:8080` to access the static files.
5. To test the API endpoints, you can use tools like cURL or Postman, or make requests from your JavaScript code.

For example:
- To get all people: `http://localhost:8080/api/people`
- To get a person by ID: `http://localhost:8080/api/people/1`
- To perform a calculation: `http://localhost:8080/api/calculate?num1=10&num2=5`

Remember to populate the `people` slice with