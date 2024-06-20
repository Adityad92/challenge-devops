**5. Simple Chat Server:**

* **Project:** Build a basic chat server using Go's concurrency features. This server can:
    * Accept connections from multiple clients.
    * Allow clients to send and receive messages.
    * Handle message broadcasting to all connected clients.
* **Learning:**  You'll learn about network programming, handling multiple connections, and using Go's goroutines and channels for concurrency.



Certainly! Let's build a basic chat server in Go that utilizes concurrency features. Here's an example implementation:

```go
package main

import (
    "bufio"
    "fmt"
    "net"
    "strings"
)

type client struct {
    conn net.Conn
    name string
    ch   chan<- string
}

var (
    entering = make(chan client)
    leaving  = make(chan client)
    messages = make(chan string)
)

func main() {
    listener, err := net.Listen("tcp", ":8080")
    if err != nil {
        fmt.Println("Error starting the server:", err)
        return
    }
    defer listener.Close()

    go broadcaster()

    fmt.Println("Chat server started. Listening on port 8080...")

    for {
        conn, err := listener.Accept()
        if err != nil {
            fmt.Println("Error accepting connection:", err)
            continue
        }

        go handleConnection(conn)
    }
}

func broadcaster() {
    clients := make(map[client]bool)

    for {
        select {
        case msg := <-messages:
            for cli := range clients {
                cli.ch <- msg
            }

        case cli := <-entering:
            clients[cli] = true
            var names []string
            for c := range clients {
                names = append(names, c.name)
            }
            cli.ch <- fmt.Sprintf("Current users: %s", strings.Join(names, ", "))

        case cli := <-leaving:
            delete(clients, cli)
            close(cli.ch)
        }
    }
}

func handleConnection(conn net.Conn) {
    ch := make(chan string)
    go clientWriter(conn, ch)

    who := conn.RemoteAddr().String()
    cli := client{conn, who, ch}
    entering <- cli

    input := bufio.NewScanner(conn)
    for input.Scan() {
        messages <- fmt.Sprintf("%s: %s", cli.name, input.Text())
    }

    leaving <- cli
    conn.Close()
}

func clientWriter(conn net.Conn, ch <-chan string) {
    for msg := range ch {
        fmt.Fprintln(conn, msg)
    }
}
```

Let's go through the code:

1. We define a `client` struct that represents a connected client. It contains the client's connection (`net.Conn`), name (initially set to the remote address), and a channel for sending messages to the client.

2. We create three channels: `entering` for new clients joining, `leaving` for clients leaving, and `messages` for broadcasting messages to all clients.

3. In the `main` function, we start a TCP server listening on port 8080. We launch a goroutine for the `broadcaster` function to handle message broadcasting.

4. In the `broadcaster` function, we maintain a map of connected clients. We use a `select` statement to handle different events:
   - When a message is received on the `messages` channel, we iterate over all connected clients and send the message to their respective channels.
   - When a new client joins (received on the `entering` channel), we add the client to the map and send a message to the client with the list of currently connected users.
   - When a client leaves (received on the `leaving` channel), we remove the client from the map and close their channel.

5. The `handleConnection` function is called for each client connection. It creates a new channel for the client and starts a goroutine for the `clientWriter` function to handle sending messages to the client.

6. In the `handleConnection` function, we read input from the client using a `bufio.Scanner`. Each line of input is sent as a message to the `messages` channel, prefixed with the client's name.

7. When the client disconnects, we send the client to the `leaving` channel and close the connection.

8. The `clientWriter` function receives messages from the client's channel and writes them to the client's connection.

To run the chat server, save the code in a file named `main.go` and execute the following command:

```
go run main.go
```

The chat server will start listening on port 8080. Clients can connect to