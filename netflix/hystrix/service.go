package main

import (
  "net/http"
  "time"
  "fmt"
  "os"
  "encoding/json"
  "math/rand"
)

type S1Handler struct {
}

func (self *S1Handler) ServeHTTP ( w http.ResponseWriter, r *http.Request) {
  if (rand.Int() % 10) == 0 {
    w.WriteHeader(500) // ServerError
  } else {
    w.WriteHeader(200) // OK
  }
  fmt.Fprintf(w, "Content-Type: application/json\r\n")
  resp := map[string]string {
    "this": "that",
  }
  data, err := json.Marshal(resp)
  if err != nil {
    panic(err)
  }
  num, err := w.Write(data)
  if err != nil {
    panic(err)
  }
  fmt.Fprintf(os.Stderr, "%d bytes written of %d\n", num, len(data))
}

func MakeService(addr string, handler http.Handler) *http.Server {
  s1 := http.Server{
    Addr:            addr,
    Handler:         handler,
    ReadTimeout:     10 * time.Second,
    WriteTimeout:    10 * time.Second,
    MaxHeaderBytes:  1 << 20, // 1mb
  }

  return &s1
}

func main () {
  var done chan bool
  s1Handler := &S1Handler{}
  s1 := MakeService(":8080", s1Handler)

  s2Handler := &S1Handler{}
  s2 := MakeService(":8081", s2Handler)

  go func () {
    fmt.Fprintf(os.Stderr, "s1=%s\n", s1)
    err := s1.ListenAndServe()
    if err != nil {
      panic(err)
    }
    done <- true
  }()

  go func () {
    fmt.Fprintf(os.Stderr, "s2=%s\n", s2)
    err := s2.ListenAndServe()
    if err != nil {
      panic(err)
    }
    done <- true
  }()

  <-done
  <-done
}
