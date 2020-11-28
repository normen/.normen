## tmux
```bash
tmux new -s mysession
tmux new -A -s mysession # attaches if exists
tmux attach -t mysession
tmux kill-session -t mysession
```
#### Keys
```
:list-keys - list all bindings
:new -s new-session

prefix + <Ctrl-s> - save session (uses session.vim)
prefix + <Ctrl-r> - save session (uses session.vim)
prefix + s - switch session
prefix + w - switch window
prefix + c - create window in session
prefix + C - create session
prefix + n/p - next/previous window

prefix + ! - separate to new window
prefix + @ - separate to session
prefix + m - mark pane
prefix + tf - paste pane to session
prefix + th - paste pane horizontally
prefix + tv - paste pane vertically

h, -, ": join horizontally
v, |, %: join vertically
f, @: join full screen
```
