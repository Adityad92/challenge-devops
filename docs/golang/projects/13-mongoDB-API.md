Certainly! Below is the complete Go code to set up a simple RESTful API server that performs CRUD operations (Create, Read, Update, Delete) for customer data containing only `Name`, `Address`, and `Phone`.   
  
```go  
package main  
   
import (  
	"context"  
	"encoding/json"  
	"fmt"  
	"log"  
	"net/http"  
	"time"  
  
	"github.com/gorilla/mux" // You'll need to use the Gorilla Mux router, install it using: go get -u github.com/gorilla/mux  
  
	"go.mongodb.org/mongo-driver/bson"  
	"go.mongodb.org/mongo-driver/bson/primitive"  
	"go.mongodb.org/mongo-driver/mongo"  
	"go.mongodb.org/mongo-driver/mongo/options"  
)  
   
// Customer represents the customer data structure.  
type Customer struct {  
	ID      primitive.ObjectID `bson:"_id,omitempty"`  
	Name    string             `bson:"name" json:"name"`  
	Address string             `bson:"address" json:"address"`  
	Phone   string             `bson:"phone" json:"phone"`  
}  
   
// getCustomerCollection connects to MongoDB and returns a customer collection.  
func getCustomerCollection() *mongo.Collection {  
	clientOptions := options.Client().ApplyURI("mongodb://localhost:27017")  
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)  
	defer cancel()  
  
	client, err := mongo.Connect(ctx, clientOptions)  
	if err != nil {  
		log.Fatal(err)  
	}  
  
	return client.Database("customerdb").Collection("customers")  
}  
   
// CreateCustomer inserts a new customer into the database.  
func CreateCustomer(w http.ResponseWriter, r *http.Request) {  
	w.Header().Set("Content-Type", "application/json")  
	var customer Customer  
	if err := json.NewDecoder(r.Body).Decode(&customer); err != nil {  
		http.Error(w, err.Error(), http.StatusBadRequest)  
		return  
	}  
  
	collection := getCustomerCollection()  
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)  
	defer cancel()  
  
	result, err := collection.InsertOne(ctx, customer)  
	if err != nil {  
		http.Error(w, err.Error(), http.StatusInternalServerError)  
		return  
	}  
  
	json.NewEncoder(w).Encode(result)  
}  
   
// GetCustomers retrieves all customers from the database.  
func GetCustomers(w http.ResponseWriter, r *http.Request) {  
	w.Header().Set("Content-Type", "application/json")  
	var customers []Customer  
  
	collection := getCustomerCollection()  
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)  
	defer cancel()  
  
	cursor, err := collection.Find(ctx, bson.M{})  
	if err != nil {  
		http.Error(w, err.Error(), http.StatusInternalServerError)  
		return  
	}  
	defer cursor.Close(ctx)  
  
	for cursor.Next(ctx) {  
		var customer Customer  
		cursor.Decode(&customer)  
		customers = append(customers, customer)  
	}  
  
	if err := cursor.Err(); err != nil {  
		http.Error(w, err.Error(), http.StatusInternalServerError)  
		return  
	}  
  
	json.NewEncoder(w).Encode(customers)  
}  
   
// GetCustomer retrieves a single customer by ID from the database.  
func GetCustomer(w http.ResponseWriter, r *http.Request) {  
	w.Header().Set("Content-Type", "application/json")  
	params := mux.Vars(r)  
	id, _ := primitive.ObjectIDFromHex(params["id"])  
  
	var customer Customer  
  
	collection := getCustomerCollection()  
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)  
	defer cancel()  
  
	err := collection.FindOne(ctx, bson.M{"_id": id}).Decode(&customer)  
	if err != nil {  
		http.Error(w, err.Error(), http.StatusNotFound)  
		return  
	}  
  
	json.NewEncoder(w).Encode(customer)  
}  
   
// UpdateCustomer updates an existing customer by ID in the database.  
func UpdateCustomer(w http.ResponseWriter, r *http.Request) {  
	w.Header().Set("Content-Type", "application/json")  
	params := mux.Vars(r)  
	id, _ := primitive.ObjectIDFromHex(params["id"])  
  
	var customer Customer  
	if err := json.NewDecoder(r.Body).Decode(&customer); err != nil {  
		http.Error(w, err.Error(), http.StatusBadRequest)  
		return  
	}  
  
	collection := getCustomerCollection()  
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)  
	defer cancel()  
  
	update := bson.M{  
		"$set": customer,  
	}  
  
	result, err := collection.UpdateByID(ctx, id, update)  
	if err != nil {  
		http.Error(w, err.Error(), http.StatusInternalServerError)  
		return  
	}  
  
	json.NewEncoder(w).Encode(result)  
}  
   
// DeleteCustomer deletes a customer by ID from the database.  
func DeleteCustomer(w http.ResponseWriter, r *http.Request) {  
	w.Header().Set("Content-Type", "application/json")  
	params := mux.Vars(r)  
	id, _ := primitive.ObjectIDFromHex(params["id"])  
  
	collection := getCustomerCollection()  
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)  
	defer cancel()  
  
	result, err := collection.DeleteOne(ctx, bson.M{"_id": id})  
	if err != nil {  
		http.Error(w, err.Error(), http.StatusInternalServerError)  
		return  
	}  
  
	json.NewEncoder(w).Encode(result)  
}  
   
// main function to boot up everything  
func main() {  
	router := mux.NewRouter()  
  
	router.HandleFunc("/customer", CreateCustomer).Methods("POST")  
	router.HandleFunc("/customers", GetCustomers).Methods("GET")  
	router.HandleFunc("/customer/{id}", GetCustomer).Methods("GET")  
	router.HandleFunc("/customer/{id}", UpdateCustomer).Methods("PUT")  
	router.HandleFunc("/customer/{id}", DeleteCustomer).Methods("DELETE")  
  
	fmt.Println("Server is running at http://localhost:8000/")  
	log.Fatal(http.ListenAndServe(":8000", router))  
}  
```  
   
This completes the implementation of all CRUD operations for the customer data structure containing `Name`, `Address`, and `Phone`. The main function uses the Gorilla Mux router to define the routes for each HTTP method corresponding to the CRUD operations.  
   
Please note the following important points:  
   
- Before running this code, ensure you have MongoDB running on `localhost:27017` and have installed the Gorilla Mux package using `go get -u github.com/gorilla/mux`.  
- Proper error handling is implemented to respond with the appropriate HTTP status codes and error messages when something goes wrong.  
- The `main` function sets up the server to listen on `localhost` port `8000`, and the router handles different routes for different CRUD operations.  
- The `ID` field of `Customer` is of type `primitive.ObjectID`, which is used to uniquely identify documents in MongoDB. The `GetCustomer`, `UpdateCustomer`, and `DeleteCustomer` functions extract the `id` parameter from the URL to perform operations on specific documents.  
   
You can run this code by saving it to a file (e.g., `main.go`), and then use the following commands in your terminal:  
   
```sh  
go mod init mycustomerapi  
go mod tidy  
go run main.go  
```  
   
This will start the server, and you can use tools like `curl` or Postman to test the API endpoints.