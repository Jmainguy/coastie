package main

import "net"
import "fmt"
import "bufio"

func handleConnection(c net.Conn) {
	fmt.Printf("Serving %s\n", c.RemoteAddr().String())
    for {
	    message, _ := bufio.NewReader(c).ReadString('\n')
	    response := ""
	    if message == "Annie, are you ok?\n" {
            message = fmt.Sprintf("Client: %s", message)
            fmt.Printf(message)
		    response = fmt.Sprintln("So, Annie are you ok?")
		    c.Write([]byte(response))
		    c.Close()
	    } else if message != "" {
            message = fmt.Sprintf("Client: %s", message)
        }
    }
}

func main() {

	fmt.Println("Launching server...")

	// listen on all interfaces
	ln, _ := net.Listen("tcp", ":8081")

	for {
		c, err := ln.Accept()
		if err != nil {
			fmt.Println(err)
			return
		}
		go handleConnection(c)
	}
}
