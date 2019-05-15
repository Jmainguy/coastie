package main

import (
    "fmt"
    "os"
    "net/http"
    "flag"
)

func main() {

    hostname := flag.String("hostname", "", "hostname to connect to")

    flag.Parse()

    url := fmt.Sprintf("http://%s/ruok", *hostname)
    resp, err := http.Get(url)
    if err != nil {
        fmt.Println("ERROR: http check failed - ", err)
        os.Exit(1)
    }
    defer resp.Body.Close()
    if resp.StatusCode == 200 {
        fmt.Println("SUCCESS: http check passed")
        os.Exit(0)
    } else {
        fmt.Println("ERROR: http check failed - %s", err)
        os.Exit(1)
    }

}
