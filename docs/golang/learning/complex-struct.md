Sure, let's explore a more complex struct example in Go. We'll create a struct called `Person` that has nested structs and slices.

```go
package main

import "fmt"

// Defining a struct for Address
type Address struct {
    Street string
    City   string
    State  string
}

// Defining a struct for Job
type Job struct {
    Company   string
    Title     string
    StartYear int
}

// Defining the Person struct
type Person struct {
    Name        string
    Age         int
    HomeAddress Address
    WorkAddress Address
    Jobs        []Job
}

func main() {
    // Creating instances of Address struct
    homeAddress := Address{
        Street: "123 Main St",
        City:   "Anytown",
        State:  "CA",
    }

    workAddress := Address{
        Street: "456 Office Rd",
        City:   "Metropolis",
        State:  "NY",
    }

    // Creating instances of Job struct
    job1 := Job{
        Company:   "Acme Inc.",
        Title:     "Software Engineer",
        StartYear: 2015,
    }

    job2 := Job{
        Company:   "Globex Corp.",
        Title:     "Senior Developer",
        StartYear: 2020,
    }

    // Creating an instance of Person struct
    person := Person{
        Name:        "John Doe",
        Age:         35,
        HomeAddress: homeAddress,
        WorkAddress: workAddress,
        Jobs:        []Job{job1, job2},
    }

    // Accessing struct fields
    fmt.Println("Name:", person.Name)
    fmt.Println("Age:", person.Age)
    fmt.Println("Home Address:", person.HomeAddress)
    fmt.Println("Work Address:", person.WorkAddress)
    fmt.Println("Jobs:")
    for _, job := range person.Jobs {
        fmt.Printf("  Company: %s, Title: %s, Start Year: %d\n", job.Company, job.Title, job.StartYear)
    }
}
```

In this example, we have:

1. An `Address` struct with `Street`, `City`, and `State` fields.
2. A `Job` struct with `Company`, `Title`, and `StartYear` fields.
3. A `Person` struct with `Name`, `Age`, `HomeAddress`, `WorkAddress`, and `Jobs` fields. The `HomeAddress` and `WorkAddress` fields are of type `Address`, and the `Jobs` field is a slice of `Job` structs.

In the `main` function:

- We create instances of `Address` for home and work addresses.
- We create instances of `Job` for two different jobs.
- We create an instance of `Person` with the above addresses and jobs.
- We access and print the fields of the `Person` struct using dot notation.
- We iterate over the `Jobs` slice and print the details of each job.

When you run this code, you'll see the following output:

```
Name: John Doe
Age: 35
Home Address: {123 Main St Anytown CA}
Work Address: {456 Office Rd Metropolis NY}
Jobs:
  Company: Acme Inc., Title: Software Engineer, Start Year: 2015
  Company: Globex Corp., Title: Senior Developer, Start Year: 2020
```

In this example, we demonstrated how to create nested structs (`Address` inside `Person`), slices of structs (`Jobs` slice of `Job` structs), and how to access and manipulate the data within these complex data structures.

Structs in Go can be as simple or as complex as needed, allowing you to model real-world entities and relationships in your code. By combining structs, slices, and other data types, you can create rich and expressive data structures tailored to your application's needs.