package main

import (
    "net"
    "bufio"
    "fmt"
    "os"
)

func main() {

    // Connect
    c, err := net.Dial("tcp", "localhost:8081")
    if err != nil {
        fmt.Println("Server aint there bruh")
        os.Exit(1)
    }
    // Send message
    question := fmt.Sprintln("Annie, are you ok?\n")
    c.Write([]byte(question))
    // Read response
    message, _ := bufio.NewReader(c).ReadString('\n')
    if message == "Annie, are you ok?\n" {
        message = fmt.Sprintf("Server: %s", message)
        fmt.Printf(message)
        c.Close()
        os.Exit(0)
    } else if message != "" {
        message = fmt.Sprintf("Server: %s", message)
        fmt.Printf(message)
    }

}
