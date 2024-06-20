Sure, let's go through another example to create methods in Go step by step:

1. First, we'll define a struct called `Rectangle` with two fields: `length` and `width`.

```go
type Rectangle struct {
    length float64
    width  float64
}
```

2. Next, we'll create a method called `area` that calculates the area of a rectangle. To define a method, we use the syntax `func (receiver_name receiver_type) method_name(parameters) return_type { ... }`.

```go
func (r Rectangle) area() float64 {
    return r.length * r.width
}
```

Here, `r` is the receiver name (an instance of `Rectangle`), and `Rectangle` is the receiver type. The method `area` takes no parameters and returns a `float64` value.

Inside the method, we use `r.length` and `r.width` to access the `length` and `width` fields of the `Rectangle` instance `r`.

3. Let's define another method called `perimeter` that calculates the perimeter of a rectangle.

```go
func (r Rectangle) perimeter() float64 {
    return 2 * (r.length + r.width)
}
```

This method follows the same structure as the `area` method.

4. Now, let's create an instance of the `Rectangle` struct and call its methods.

```go
func main() {
    rect := Rectangle{length: 5.0, width: 3.0}
    fmt.Println("Area:", rect.area())
    fmt.Println("Perimeter:", rect.perimeter())
}
```

In the `main` function, we create a `Rectangle` instance with `length` 5.0 and `width` 3.0. Then, we call the `area` and `perimeter` methods on this instance using the dot notation (`rect.area()` and `rect.perimeter()`).

5. The complete code looks like this:

```go
package main

import "fmt"

type Rectangle struct {
    length float64
    width  float64
}

func (r Rectangle) area() float64 {
    return r.length * r.width
}

func (r Rectangle) perimeter() float64 {
    return 2 * (r.length + r.width)
}

func main() {
    rect := Rectangle{length: 5.0, width: 3.0}
    fmt.Println("Area:", rect.area())
    fmt.Println("Perimeter:", rect.perimeter())
}
```

When you run this code, it will output:

```
Area: 15
Perimeter: 16
```

In this example, we defined two methods (`area` and `perimeter`) on the `Rectangle` struct. These methods operate on instances of the `Rectangle` struct and perform calculations based on the `length` and `width` fields.

To call a method, you use the dot notation (`instance.method_name()`) on an instance of the struct. The method has access to the fields of the instance through the receiver (`r` in this case).