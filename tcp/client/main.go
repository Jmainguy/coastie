package main

import (
    "net"
    "bufio"
    "fmt"
    "os"
    "flag"
)

func main() {

    node := flag.String("node", "", "Node to connect to")
    port := flag.String("port", "", "Port to connect to")

    flag.Parse()

    // Node + port
    nodePort := fmt.Sprintf("%s:%s", *node, *port)
    // Connect
    c, err := net.Dial("tcp", nodePort)
    if err != nil {
        fmt.Println("ERROR: TCP unable to connect")
        os.Exit(1)
    }
    // Send message
    question := fmt.Sprintln("Annie, are you ok?\n")
    c.Write([]byte(question))
    // Read response
    message, _ := bufio.NewReader(c).ReadString('\n')
    if message == "So, Annie are you ok?\n" {
        message = fmt.Sprintf("Server: %s", message)
        fmt.Println("SUCCESS: TCP is working")
        c.Close()
        os.Exit(0)
    } else if message != "" {
        message = fmt.Sprintf("Server: %s", message)
        fmt.Printf(message)
    }

}
