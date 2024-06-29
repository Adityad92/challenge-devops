Sure! Let's create the same project using Go and the Gorilla Mux library for routing.

Project: HTTP Security Headers

Prerequisites:
- Go installed

Step 1: Create a new directory for the project and navigate to it:
```
mkdir http-security-headers
cd http-security-headers
```

Step 2: Initialize a new Go module:
```
go mod init github.com/yourusername/http-security-headers
```

Step 3: Create a new file named `main.go` with the following code:
```go
package main

import (
    "log"
    "net/http"

    "github.com/gorilla/mux"
)

func main() {
    router := mux.NewRouter()

    // Middleware to set HTTP security headers
    router.Use(securityHeadersMiddleware)

    // Route handler for the home page
    router.HandleFunc("/", homeHandler)

    // Start the server
    port := ":3000"
    log.Printf("Server is running on port %s", port)
    log.Fatal(http.ListenAndServe(port, router))
}

func securityHeadersMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // Set HTTP security headers
        w.Header().Set("X-Content-Type-Options", "nosniff")
        w.Header().Set("X-Frame-Options", "SAMEORIGIN")
        w.Header().Set("X-XSS-Protection", "1; mode=block")
        w.Header().Set("Referrer-Policy", "strict-origin-when-cross-origin")
        w.Header().Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains")

        next.ServeHTTP(w, r)
    })
}

func homeHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("Welcome to the HTTP Security Headers example!"))
}
```

Step 4: Install the Gorilla Mux library:
```
go get github.com/gorilla/mux
```

Step 5: Run the server:
```
go run main.go
```

Step 6: Open a web browser and visit `http://localhost:3000`. You should see the message "Welcome to the HTTP Security Headers example!".

Step 7: Open the browser's developer tools and inspect the network request to see the security headers set by the server.

Explanation:
- We create a new Gorilla Mux router to handle routing in the Go application.
- We define a middleware function `securityHeadersMiddleware` that sets various HTTP security headers:
  - `X-Content-Type-Options: nosniff` - Prevents the browser from trying to guess the MIME type of a response and forces it to use the declared Content-Type.
  - `X-Frame-Options: SAMEORIGIN` - Prevents the page from being loaded in an iframe on other domains, helping to prevent clickjacking attacks.
  - `X-XSS-Protection: 1; mode=block` - Enables the browser's built-in XSS protection and instructs it to block the page if an XSS attack is detected.
  - `Referrer-Policy: strict-origin-when-cross-origin` - Controls the information sent in the Referer header when navigating from the page to other origins.
  - `Strict-Transport-Security: max-age=31536000; includeSubDomains` - Enforces HTTPS connections and instructs the browser to always use HTTPS for future requests to the domain.
- The middleware function is attached to the router using `router.Use(securityHeadersMiddleware)`, ensuring that the security headers are set for all routes.
- The server defines a route handler for the home page ('/') that sends a simple welcome message.
- The server starts listening on port 3000.

When you visit the application in a web browser, you can inspect the network request and see the security headers set by the server. These headers provide additional security measures to protect against various web vulnerabilities and attacks.

Note: The specific security headers and their values used in this example are just a subset of the available options. The choice of headers and their configurations depends on the specific security requirements of your application.