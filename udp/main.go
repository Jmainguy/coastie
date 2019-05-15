package main

import (
	"fmt"
	"net"
	"time"
)

func sendResponse(conn *net.UDPConn, addr *net.UDPAddr, msg string) {
	// Sleep a little bit, response is too fast otherwise
	time.Sleep(100 * time.Millisecond)
	// Now send that message
	_, err := conn.WriteToUDP([]byte(msg), addr)
	if err != nil {
		fmt.Printf("Couldn't send response %v", err)
	}
}

func main() {

	// We are listening at this port and address
	addr := net.UDPAddr{
		Port: 8082,
		IP:   net.ParseIP("0.0.0.0"),
	}
	// Start listening
	conn, err := net.ListenUDP("udp", &addr) // code does not block here
	if err != nil {
		panic(err)
	}

	// Need a buffer, 1024 bytes sounds right, no message will be bigger than that, if it is, just read the first 1024
	var buf [1024]byte
	for {
		// Read the length of response, and the address of the person talking
		rlen, remoteAddr, _ := conn.ReadFromUDP(buf[:])
		// From start of buffer, 0, to end of response length, convert byte into a string (what did they say?)
		msg := string(buf[0:rlen])
		// Print who said it
		fmt.Println(remoteAddr)
		// Print what they said
		fmt.Printf(msg)
		// Think of what to ask them
		responseMsg := "Sup Dawg?\n"
		// Ask them, don't wait on response, its udp, we arent gonna get one anyways
		go sendResponse(conn, remoteAddr, responseMsg)
	}
}
