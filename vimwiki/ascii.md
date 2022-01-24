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
``` ansi escapes
<ESC>[{attr1};...;{attrn}m

\e[31mHello\e[0m
or Crtl-V Esc in vim

0	Reset all attributes
1	Bright
2	Dim
4	Underscore	
5	Blink
7	Reverse
8	Hidden
	Foreground Colours
30	Black
31	Red
32	Green
33	Yellow
34	Blue
35	Magenta
36	Cyan
37	White
	Background Colours
40	Black
41	Red
42	Green
43	Yellow
44	Blue
45	Magenta
46	Cyan
47	White
```
