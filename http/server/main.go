package main

import (
    "net/http"
    "io"
)


func main() {
    http.HandleFunc("/ruok", func(w http.ResponseWriter, r *http.Request) {
        io.WriteString(w, "imok")
    })
    http.ListenAndServe(":8080", nil)
}
