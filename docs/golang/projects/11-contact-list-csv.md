To convert a CSV file containing a phone book into a Go struct and then serve the data via an HTTP server, you'll need to follow these steps:  
   
1. Define a `Contact` struct to represent each record.  
2. Parse the CSV file and populate a slice of `Contact` structs.  
3. Start an HTTP server that serves the contacts.  
   
First, let's define the `Contact` struct and a function to parse the CSV file:  
   
```go  
package main  
   
import (  
	"encoding/csv"  
	"fmt"  
	"log"  
	"net/http"  
	"os"  
)  
   
// Contact represents a phone book entry  
type Contact struct {  
	Name    string `json:"name"`  
	Address string `json:"address"`  
	Phone   string `json:"phone"`  
}  
   
// readCSV reads a CSV file and returns a slice of Contacts  
func readCSV(filename string) ([]Contact, error) {  
	file, err := os.Open(filename)  
	if err != nil {  
		return nil, err  
	}  
	defer file.Close()  
  
	reader := csv.NewReader(file)  
	records, err := reader.ReadAll()  
	if err != nil {  
		return nil, err  
	}  
  
	var contacts []Contact  
	for i, record := range records {  
		if i == 0 {  
			continue // Skip the header row  
		}  
		if len(record) >= 3 {  
			contacts = append(contacts, Contact{  
				Name:    record[0],  
				Address: record[1],  
				Phone:   record[2],  
			})  
		}  
	}  
  
	return contacts, nil  
}  
```  
   
Next, we'll create an HTTP handler to serve the contacts and start the server:  
   
```go  
import (  
	"encoding/json"  
	// ... other imports  
)  
   
// contacts will hold the data that is read from the CSV  
var contacts []Contact  
   
// handleContacts sends the list of contacts as JSON  
func handleContacts(w http.ResponseWriter, r *http.Request) {  
	w.Header().Set("Content-Type", "application/json")  
	json.NewEncoder(w).Encode(contacts)  
}  
   
func main() {  
	// Load contacts from a CSV file  
	var err error  
	contacts, err = readCSV("phonebook.csv")  
	if err != nil {  
		log.Fatalf("Error reading CSV file: %v", err)  
	}  
  
	// Set up the HTTP server  
	http.HandleFunc("/contacts", handleContacts)  
  
	fmt.Println("Server starting on port 8080...")  
	if err := http.ListenAndServe(":8080", nil); err != nil {  
		log.Fatal(err)  
	}  
}  
```  
   
To run your server, execute the command:  
   
```sh  
go run main.go  
```  
   
Now, your server will be serving the contacts at `http://localhost:8080/contacts`. You can test it using a browser or a tool like `curl`:  
   
```sh  
curl http://localhost:8080/contacts  
```  
   
Remember to replace `"phonebook.csv"` with the path to your actual CSV file. The CSV file should have a header row with the columns "Name", "Address", and "Phone", followed by 20 records. Here's an example format for the CSV:  
   
```csv  
Name,Address,Phone  
John Doe,123 Elm St,(555) 123-4567  
Jane Smith,456 Maple Ave,(555) 987-6543  
...  
```  
   
This example assumes the CSV file is correctly formatted with no need for special error handling. In a real-world scenario, you would want to add more robust error checking, validation, and potentially authentication for accessing the contacts data.