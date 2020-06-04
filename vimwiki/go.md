## go
#### Project
```bash
## modules!
cd ~/go
mkdir src
cd src
mkdir project
touch main.go
go run main.go
go build
go install
```

#### Basics
```go
package main

import (
  "fmt"
  "errors"
)

func main() {
  fmt.Println("Hello World")
  // variables
  var name int = 0
  // same result:
  name := 0
  fmt.Println(name)

  // fixed array
  var arr = [5]int

  // slice (range of managed backing array)
  var arr = []int{1,2,3}
  append(arr,4)

  // maps
  myMap := make(map[string]int)
  myMap["Eins"] = 1
  myMap["Zwei"] = 2
  delete(myMap, "Eins")

  // for is while!
  vari := 0
  for vari < 10 {
    vari++
  }

  // loop over array or map
  for index, value := range arr {
  }
}

func sum(x int, y int) (int, error) {
  if y < 0 {
    return errors.New("x can't be below zero")
  }
  return x + y
}

// types - "classes"
type myStruct struct {
  name string
  age int
}

// methods for types, name of "this" can be anything
func (this myStruct) setName(name string) {
  this.name = name
}

func main() {
  p := myStruct{name:"Name", age:8}
  myStruct.setName("Normen")
  fmt.Println(p.name)
}

// pointers
*vari := 5
varx := 5
*vary = &varx
```

#### Concurrency
```go
// concurrency
package main

import (
  "fmt"
  "time"
  "sync"
)

func main() {
  go count("sheep")
  count("fish")

  fmt.Scanln() // get input
}

func count(thing string) {
  for i:=0; i<100; i++ {
    fmt.Println(i, thing)
    time.Sleep(time.Milliseconds * 500)
  }
}

// with sync / wait
func main (){
  var wg sync.WaitGroup
  wg.Add(1)
  go func() {
    count("sheep")
    wg.Done()
  }()
  wg.Wait()
}

```

#### Channels
```go
// with channel
func main() {
  // make channel, for capacity (chan string, 10) 
  c := make(chan string)
  go count("sheep", c)
  // wait for data once
  msg := <- c
  fmt.Println(msg)
  // read til closed,
  // alternatively msg, closed := <-c
  for msg := range(c) {
    fmt.Println(msg)
  }
}

func count(thing string, c chan string) {
  for i:=0; i<100; i++ {
    // send data (blocks if channel full)
    c <- thing
    time.Sleep(time.Milliseconds * 500)
  }
  // close channel
  close(c)
}

// drain multiple channels with select
func main() {
  select {
    case msg1 := <- c1:
      fmt.Println(msg1)
    case msg2 := <- c2:
      fmt.Println(msg2)
  }
}
```
