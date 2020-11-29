## VIM
- [vimscript](vimscript.md)
#### Noob Stuff
```
<Esc> - enter normal mode
:q - quit
:w - save
:w filename.txt - save as other file, edit old
:sav filename.txt - save as new file, edit new
i - insert mode
I - insert mode at first non-blank
a - insert mode after cursor
A - append eol
o - open new line after cursor
O - open new line before cursor
x - delete char
r - replace char
R - replace multiple chars
u - undo
Ctrl-r - redo

C-d - down half page
C-u - up half page
C-f - forward one page
C-b - back one page
H, M, L - go to high, middle, low in visible window
[], ][, [[, ]] - move between sections

:ws - save&quit
:q! - quit w/o saving
```
#### File Handling
```
:find name<Tab> - find file
:e . - open file browser (:edit .)
:tabf name<Tab> - find and open in tab
:tabe . - browse and open in tab
:args *.js - open all files as buffers (:next
:Lexplore - vertical split file explorer (gn, cd)
:idoc - ios open file
:idoc dir - ios open directory

:ls - show open files
:b filen - open of opened files (partial name)
:bd - buffer delete (close open file)
gF - go to file under cursor, allows line number
```
#### Window/Commands
```
:split - split window (vsplit, hsplit)
C-w C-w - switch window
C-w _ - window max height
C-w = - window equal height
C-w +/- - window larger/smaller
C-w o - only this window
:set wfw - set window fix width

:!command - shell command

:bufdo - do for all buffers
:tabdo bd - close all buffers in tabs

# tabs
vim -p file1 file2 file3 - open in tabs
:tabnew filename - open in new tab
:tabf inven* - find and open in new tab
:tabn - next tab (or gt)
:tabp - prev tab
:tabdo %s/foo/bar/g - replace in all tabs
:tabdo bd - close all tabs
:tab sball - open all buffers in tabs

# workspace
:mksession session.vim

# set build tool
:set makeprg=npm\ run
```
#### Editing/Movement
```
:%y - copy whole file
d$ - delete til end of line
d0 - delete til beginning of line
d^ - delete til first non-blank
d% - delete til next closing bracket (if on opening bracket)

gg - go to line 1
G - go to EOF
20G - go to line 20

fx - find x
tx - til x
; - next find/til
, - prev find/til

qa - record macro into register a
q - stop recording macro
@a - play macro a

J - join this and next line (remove CR)
~ - change case of char

mx - marker x
mX - global marker X (across files)
'x - goto marker x

dd - cut line
yy - copy line
5dd - cut 5 lines

v - select
V - select lines

gv - select again
gi - go to last insert

y - copy
d - cut
p - paste after cursor
P - paste before cursor

"*y -> copy to system 
"ay -> copy to reg. a
"by -> copy to reg. b

cw - change word
ci( - change inside (
ca{ - change all { (including{})
cs{( - change surrounding { to ( (plugin)
c} - change from here to end of next block!
cf" - change find end (incl)
ct" - change til (excl)
c/search  - change to search
. - repeat change (no :commands)

# select function
va}V - selects outer } then goes to line mode

# im/export from/to files
v - select - :w FILE - save selection to new file
:r FILE - load file contens to current file
:r !command - load command output to current file

> - indent

vii - visual select inside indentation

:retab - change tabs in doc
= - format
gg=G - format file

:cd %:h - go to current file dir
```
#### Autocomplete/Special
```
# docs for language
K - on word

# autocomplete (insert mode)
C-n - autocomplete from after
C-p - autocomplete from before
C-x C-n - autocomplete in file
C-x C-f - autocomplete filename
C-x C-] - autocomplete tags
C-x C-l - autocomplete line
C-x C-o - autocomplete omni

# insert mode
C-r - insert register
C-a - insert last insert

C-] - go to def
C-t - go back

C-v + <Tab> - insert real Tab
C-v + <Esc> - insert real <Esc>

/searchtext - find
n - next found
N - prev found
:%s/findtext/replacetext/g - replace text in whole file, no g = only first, no % = only line, gc = ask
# vimgrep 
:vim /TODO/ %
:vim /TODO/g **/*

* - go to next occurrence of current word
# - go to prev occurrence 

:noh - remove highlights
:set ic - ignore case
:set noic - no ignore case
:set hls is - highlight + increment search
```
#### CoC
```
<Tab> - expand
[x ]x - go to next/prev issue
gd - go to definition
gy - type definition
gi - implementation
gr - references
<Leader>qf - quick fix
<Leader>rn - refactor-rename
<Leader>ac - code action on file
<space>a - all diagnostics
<space>e - extensions
<space>c - commands
<space>o - outline doc
<space>s - symbols
<space>p - resume last

:Format - format code
:Fold - fold code (zo to open)
:OR - organize imports

:noa w - save without format
```
#### Plugins
```
# gitgutter
[c ]c - go to next/prev change
,hu - undo hunk
,hp - preview hunk
,hs - stage hunk
,dic - delete inside hunk
,dac - delete outside hunk (incls space)

# fugitive - resolve
:Gdiff
dp - each hunk on side to keep
:GWrite - save this version (any side or middle)

# surround
cs"' - change surrounding " to '
ds" - delete surrounding "
ysiw( - surround inner word with (


```
#### Scripts/Build
```
# numbers
C-a / C-x - inc/dec numbers
gC-a - sequential increment

# set register to..
:let @a = "hello!"
"ap - paste

# comment
C-V - select block first char
shift-i - insert block
- enter comment char(s)
<Esc>

# templates
nnoremap ,mytemp :-lread $HOME/.vim/.mytemplate.js<CR>

#### BUILDING VIM
sudo apt install ncurses-dev python3-dev
git clone https://github.com/vim/vim.git vim-master
cd vim-master
cd src
./configure --prefix=/usr/local --enable-python3interp
make -j 4
sudo make install

#### add make types
:set ft=homebridge
#ftplugin/homebridge.vim
set makeprg=homebridge\ -I\ -U\ ~/npm-code/testhomebridge/.homebridge
set errorformat=....
```
