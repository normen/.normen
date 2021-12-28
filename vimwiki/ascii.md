```
                _ _ 
  __ _ ___  ___(_|_)
 / _` / __|/ __| | |
| (_| \__ \ (__| | |
 \__,_|___/\___|_|_|
                    
```
```
brew install figlet
pip install diagram
go get github.com/qeesung/image2ascii
cpan install Graph::Easy

```
```
digraph {
  start -> adsuck;
  adsuck -> block;
  block -> noop[label="yes"];
  block -> unbound[label="no"];
  noop -> serve_noop[label="yes"];
  noop -> serve_empty[label="no"];
}
```
