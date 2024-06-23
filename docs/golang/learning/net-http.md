The `net/http` package in Go is a powerful tool for building HTTP clients and servers. By focusing on the 80-20 principle, we'll cover the most common and useful features that will handle the majority of HTTP-related tasks.  
   
1. **Creating HTTP Servers**:  
   - `http.ListenAndServe(addr string, handler http.Handler) error`: Starts an HTTP server with a given address and handler. The handler is usually nil, which means to use `http.DefaultServeMux`.  
   - `http.HandleFunc(pattern string, handler func(http.ResponseWriter, *http.Request))`: Registers a handler function for a given pattern with the default serve mux.  
   
2. **Handling HTTP Requests**:  
   - `http.Request`: Represents an HTTP request received by a server or sent by a client.  
   - `http.ResponseWriter`: An interface used by an HTTP handler to construct an HTTP response.  
   
3. **Creating HTTP Clients**:  
   - `http.Get(url string) (resp *http.Response, err error)`: Sends an HTTP GET request.  
   - `http.Post(url, contentType string, body io.Reader) (resp *http.Response, err error)`: Sends an HTTP POST request.  
   
4. **Working with HTTP Responses**:  
   - `http.Response`: Represents the response from an HTTP server.  
   
**Scenarios**:  
   
- **Setting Up a Simple Web Server**: When you want to serve HTTP requests in Go, use `http.ListenAndServe` and `http.HandleFunc`.  
   
```go  
http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {  
    fmt.Fprintln(w, "Hello, World!")  
})  
   
err := http.ListenAndServe(":8080", nil)  
if err != nil {  
    log.Fatal(err)  
}  
```  
   
- **Reading Request Data**: To read data from an HTTP request, such as query parameters or the request body, use the `http.Request` object.  
   
```go  
http.HandleFunc("/greet", func(w http.ResponseWriter, r *http.Request) {  
    name := r.URL.Query().Get("name")  
    if name == "" {  
        name = "Guest"  
    }  
    fmt.Fprintf(w, "Hello, %s!", name)  
})  
```  
   
- **Sending an HTTP GET Request**: When your application needs to retrieve data from an external service, use `http.Get`.  
   
```go  
resp, err := http.Get("http://example.com")  
if err != nil {  
    log.Fatal(err)  
}  
defer resp.Body.Close()  
body, err := ioutil.ReadAll(resp.Body)  
if err != nil {  
    log.Fatal(err)  
}  
fmt.Println(string(body))  
```  
   
- **Sending an HTTP POST Request**: Use `http.Post` to send data to an external service.  
   
```go  
formData := url.Values{"key": {"Value"}, "id": {"123"}}  
resp, err := http.Post("http://example.com/post", "application/x-www-form-urlencoded", strings.NewReader(formData.Encode()))  
if err != nil {  
    log.Fatal(err)  
}  
defer resp.Body.Close()  
body, err := ioutil.ReadAll(resp.Body)  
if err != nil {  
    log.Fatal(err)  
}  
fmt.Println(string(body))  
```  
   
- **Creating a Custom HTTP Client**: If you need to customize the HTTP client, for instance, to add timeouts, use `http.Client`.  
   
```go  
client := &http.Client{Timeout: time.Second * 10}  
resp, err := client.Get("http://example.com")  
if err != nil {  
    log.Fatal(err)  
}  
defer resp.Body.Close()  
// ... read resp.Body as before  
```  
   
- **Handling JSON Responses**: When dealing with JSON APIs, you'll often need to decode JSON from the response body.  
   
```go  
type ApiResponse struct {  
    Data string `json:"data"`  
}  
   
resp, err := http.Get("http://example.com/api")  
if err != nil {  
    log.Fatal(err)  
}  
defer resp.Body.Close()  
   
var apiResp ApiResponse  
err = json.NewDecoder(resp.Body).Decode(&apiResp) 
   
type ApiResponse struct {  
    Data string `json:"data"`  
}  
   
resp, err := http.Get("http://example.com/api")  
if err != nil {  
    log.Fatal(err)  
}  
defer resp.Body.Close()  
   
var apiResp ApiResponse  
err = json.NewDecoder(resp.Body).Decode(&apiResp)  
if err != nil {  
    log.Fatal(err)  
}  
fmt.Println(apiResp.Data)  
```  
   
- **Working with HTTP Headers**: To set or read HTTP headers, use the `Header` map in both the `http.Request` and `http.Response` structs.  
   
```go  
// Setting request headers  
req, err := http.NewRequest("GET", "http://example.com", nil)  
if err != nil {  
    log.Fatal(err)  
}  
req.Header.Set("Authorization", "Bearer your-token")  
   
// Sending the request  
client := &http.Client{}  
resp, err := client.Do(req)  
if err != nil {  
    log.Fatal(err)  
}  
defer resp.Body.Close()  
   
// Reading response headers  
contentType := resp.Header.Get("Content-Type")  
fmt.Println("Content-Type:", contentType)  
```  
   
- **Serving Static Files**: To serve static files such as JavaScript, CSS, and images, use `http.FileServer`.  
   
```go  
http.Handle("/", http.FileServer(http.Dir("/public")))  
   
err := http.ListenAndServe(":8080", nil)  
if err != nil {  
    log.Fatal(err)  
}  
```  
   
- **Creating Middlewares**: Middlewares are handlers that wrap other handlers to perform additional functions like logging, authentication, etc.  
   
```go  
func loggingMiddleware(next http.Handler) http.Handler {  
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {  
        log.Printf("Request received: %s %s", r.Method, r.URL.Path)  
        next.ServeHTTP(w, r) // Call the next handler  
    })  
}  
   
http.Handle("/", loggingMiddleware(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {  
    fmt.Fprintln(w, "This is the main handler!")  
})))  
   
err := http.ListenAndServe(":8080", nil)  
if err != nil {  
    log.Fatal(err)  
}  
```  
   
- **Using HTTPS**: To serve traffic over HTTPS, use `http.ListenAndServeTLS`.  
   
```go  
err := http.ListenAndServeTLS(":443", "server.crt", "server.key", nil)  
if err != nil {  
    log.Fatal(err)  
}  
```  
   
These examples showcase the most common use cases for the `net/http` package in Go. By mastering these fundamental patterns, you can handle a wide range of HTTP operations, from simple server setups to complex client requests. Always be mindful of error handling and resource management, such as closing response bodies and setting appropriate timeouts for your HTTP clients.