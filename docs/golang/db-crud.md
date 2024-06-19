Certainly! Let's extend the previous example to include the other CRUD (Create, Read, Update, Delete) operations for the `users` collection in the MongoDB database using Gin.

```go
package main

import (
    "context"
    "fmt"
    "log"
    "net/http"

    "github.com/gin-gonic/gin"
    "go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/bson/primitive"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
)

type User struct {
    ID   primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
    Name string             `json:"name"`
    Age  int                `json:"age"`
}

var collection *mongo.Collection

func init() {
    // Connect to the MongoDB database
    clientOptions := options.Client().ApplyURI("mongodb://localhost:27017")
    client, err := mongo.Connect(context.Background(), clientOptions)
    if err != nil {
        log.Fatal(err)
    }

    // Access the specific database and collection
    database := client.Database("your_database_name")
    collection = database.Collection("users")
}

func createUserHandler(c *gin.Context) {
    var user User
    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // Insert the user into the database
    result, err := collection.InsertOne(context.Background(), user)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    // Send a success response
    c.JSON(http.StatusCreated, gin.H{"id": result.InsertedID})
}

func getUserHandler(c *gin.Context) {
    id := c.Param("id")
    objectID, err := primitive.ObjectIDFromHex(id)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
        return
    }

    var user User
    err = collection.FindOne(context.Background(), bson.M{"_id": objectID}).Decode(&user)
    if err != nil {
        if err == mongo.ErrNoDocuments {
            c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
        } else {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        }
        return
    }

    c.JSON(http.StatusOK, user)
}

func updateUserHandler(c *gin.Context) {
    id := c.Param("id")
    objectID, err := primitive.ObjectIDFromHex(id)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
        return
    }

    var user User
    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    update := bson.M{
        "$set": bson.M{
            "name": user.Name,
            "age":  user.Age,
        },
    }

    _, err = collection.UpdateOne(context.Background(), bson.M{"_id": objectID}, update)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "User updated successfully"})
}

func deleteUserHandler(c *gin.Context) {
    id := c.Param("id")
    objectID, err := primitive.ObjectIDFromHex(id)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
        return
    }

    _, err = collection.DeleteOne(context.Background(), bson.M{"_id": objectID})
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "User deleted successfully"})
}

func main() {
    router := gin.Default()

    router.POST("/users", createUserHandler)
    router.GET("/users/:id", getUserHandler)
    router.PUT("/users/:id", updateUserHandler)
    router.DELETE("/users/:id", deleteUserHandler)

    fmt.Println("Server is running on port 8080")
    log.Fatal(router.Run(":8080"))
}
```

In this updated example, we have added the following CRUD operations:

1. Create (POST `/users`):
   - The `createUserHandler` function handles the creation of a new user.
   - It binds the JSON request body to the `user` struct using `c.ShouldBindJSON(&user)`.
   - It inserts the user into the `users` collection using `collection.InsertOne()`.
   - It sends a success response with the inserted user's ID.

2. Read (GET `/users/:id`):
   - The `getUserHandler` function handles retrieving a user by ID.
   - It extracts the user ID from the URL parameter using `c.Param("id")`.
   - It converts the ID string to an `ObjectID` using `primitive.ObjectIDFromHex()`.
   - It finds the user in the `users` collection using `collection.FindOne()`.
   - It sends the user as a JSON response if found, or an appropriate error response.

3. Update (PUT `/users/:id`):
   - The `updateUserHandler` function handles updating a user by ID.
   - It extracts the user ID from the URL parameter and converts it to an `ObjectID`.
   - It binds the JSON request body to the `user` struct.
   - It creates an update document using `bson.M` to specify the fields to update.
   - It updates the user in the `users` collection using `collection.UpdateOne()`.
   - It sends a success response indicating that the user was updated successfully.

4. Delete (DELETE `/users/:id`):
   - The `deleteUserHandler` function handles deleting a user by ID.
   - It extracts the user ID from the URL parameter and converts it to an `ObjectID`.
   - It deletes the user from the `users` collection using `collection.DeleteOne()`.
   - It sends a success response indicating that the user was deleted successfully.

The `init()` function is used to establish a connection to the MongoDB database when the program starts. It connects to the specified MongoDB server and sets the `collection` variable to the `users` collection.

The `main()` function sets up the Gin router and defines the routes for each CRUD operation, mapping them to the corresponding handler functions.

You can test these endpoints using Postman by sending appropriate requests to the specified routes (`/users` for create and `/users/:id` for read, update, and delete operations) with the required JSON payloads.

Remember to replace `"your_database_name"` with the actual name of your MongoDB database.