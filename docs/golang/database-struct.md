Sure, let's create a simple struct that resembles a database of users. In this example, we'll have a slice of `User` structs, and we'll define methods to perform basic CRUD (Create, Read, Update, Delete) operations on the "database".

```go
package main

import (
    "fmt"
)

// User struct represents a user in the database
type User struct {
    ID        int
    Name      string
    Email     string
    Age       int
    IsPremium bool
}

// Database is a slice to store User structs
var Database []User

// AddUser creates a new user and appends it to the database
func AddUser(name, email string, age int, isPremium bool) {
    user := User{
        ID:        len(Database) + 1,
        Name:      name,
        Email:     email,
        Age:       age,
        IsPremium: isPremium,
    }
    Database = append(Database, user)
    fmt.Println("User added successfully!")
}

// GetUser retrieves a user from the database by ID
func GetUser(id int) (User, bool) {
    for _, user := range Database {
        if user.ID == id {
            return user, true
        }
    }
    return User{}, false
}

// UpdateUser updates an existing user in the database
func UpdateUser(id int, name, email string, age int, isPremium bool) bool {
    for i, user := range Database {
        if user.ID == id {
            Database[i] = User{
                ID:        id,
                Name:      name,
                Email:     email,
                Age:       age,
                IsPremium: isPremium,
            }
            fmt.Printf("User with ID %d updated successfully!\n", id)
            return true
        }
    }
    fmt.Printf("User with ID %d not found!\n", id)
    return false
}

// DeleteUser removes a user from the database by ID
func DeleteUser(id int) bool {
    for i, user := range Database {
        if user.ID == id {
            Database = append(Database[:i], Database[i+1:]...)
            fmt.Printf("User with ID %d deleted successfully!\n", id)
            return true
        }
    }
    fmt.Printf("User with ID %d not found!\n", id)
    return false
}

func main() {
    // Add some users to the database
    AddUser("John Doe", "john@example.com", 30, true)
    AddUser("Jane Smith", "jane@example.com", 25, false)
    AddUser("Bob Johnson", "bob@example.com", 40, true)

    // Get a user by ID
    user, found := GetUser(2)
    if found {
        fmt.Printf("User found: %+v\n", user)
    } else {
        fmt.Println("User not found!")
    }

    // Update a user
    UpdateUser(1, "John Doe Jr.", "john.jr@example.com", 31, true)

    // Delete a user
    DeleteUser(3)
}
```

In this example, we have:

1. A `User` struct with `ID`, `Name`, `Email`, `Age`, and `IsPremium` fields.
2. A `Database` slice to store `User` structs.
3. `AddUser` function to create a new user and append it to the `Database`.
4. `GetUser` function to retrieve a user from the `Database` by `ID`.
5. `UpdateUser` function to update an existing user in the `Database` by `ID`.
6. `DeleteUser` function to remove a user from the `Database` by `ID`.

In the `main` function:

- We add some users to the `Database` using the `AddUser` function.
- We retrieve a user by ID using the `GetUser` function.
- We update a user's information using the `UpdateUser` function.
- We delete a user from the `Database` using the `DeleteUser` function.

When you run this code, you'll see the following output:

```
User added successfully!
User added successfully!
User added successfully!
User found: {ID:2 Name:Jane Smith Email:jane@example.com Age:25 IsPremium:false}
User with ID 1 updated successfully!
User with ID 3 deleted successfully!
```

In this example, we simulated a simple database using a slice of `User` structs. The `AddUser`, `GetUser`, `UpdateUser`, and `DeleteUser` functions represent the basic CRUD operations commonly found in database management systems.

Of course, this is a very simplified example, and in real-world scenarios, you would likely use a more robust database solution like SQL or NoSQL databases. However, this example demonstrates how structs in Go can be used to model and manage data structures similar to a database.