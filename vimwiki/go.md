## go
#### Project
```bash
## install on raspi
wget https://dl.google.com/go/go1.15.2.linux-armv6l.tar.gz
sudo tar -C /usr/local -xzf go1.15.2.linux-armv6l.tar.gz
vim ~/.profile
<<CONTENT
PATH=$PATH:/usr/local/go/bin
GOPATH=$HOME/go
CONTENT
source ~/.profile

git clone https://github.com/cli/cli.git gh-cli
cd gh-cli
make
sudo cp bin/gh /usr/local/bin

## old project w/o modules
cd ~/go
mkdir src
cd src
mkdir project
touch main.go
go run main.go
go build
go install

## using modules
cd somewhere not GOPATH
mkdir myapp
cd myapp
vim main.go
<<CONTENT
package myapp
func Hello() string {
  return "Hello, world."
}
CONTENT
go mod init myname.com/myapp

# update all packages
go get -u
# get specific commit
go get github.com/someone/some_module@af044c0995fe
# replace some import with fork
# (at end of go.mod)
replace github.com/Rhymen/go-whatsapp => github.com/SchulteMK/go-whatsapp v0.0.0-20201117193111-50e7347bfbb6
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
  arr = append(arr,4)

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

GetOut: //mark for break
  // loop over array or map
  for index, value := range arr {
   break GetOut // breaks to mark
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
## Building
```bash
# get supported architectures
go tool dist list
# build for local arch
go build -o myapp
# build for other arch
GOOS=windows go build -o myapp.exe
GOOS=linux GOARCH=ppc64 go build -o myapp
# raspi
GOOS=linux GOARCH=arm GOARM=5 go build -o whatscli
```
