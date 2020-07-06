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
#### Scripts+Plugins
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
```
```bash
#### ctags
brew install ctags
ctags -R .
nnoremap <leader>t :silent !ctags -R .<CR><C-L>

#### eslint
npm install -g eslint
mkdir ~/.vim/ftplugin
vim ~/.vim/ftplugin/javascript.vim
<<CONTENT
setlocal makeprg=eslint\ --format\ compact\ %
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
CONTENT

:make - find errors
:cn - next error
:cc4 - error #4
:cw - error window

#### semistandard
npm install -g semistandard
nnoremap <leader>s :silent !semistandard % --fix<CR><C-L>

#### git plugin
git clone https://github.com/airblade/vim-gitgutter.git ~/.vim/pack/airblade/start/vim-gitgutter
:helptags ~/.vim/pack/airblade/start/vim-gitgutter/doc

\hu - undo hunk
\hp - preview hunk
\hs - stage hunk
\dic - delete inside hunk
\dac - delete outside hunk (incls space)

#### surround plugin
git clone https://tpope.io/vim/surround.git ~/.vim/pack/tpope/start/surround
:helptags ~/.vim/pack/tpope/start/surround/doc

#cs"' - change surrounding " to '
#ds" - delete surrounding "
#ysiw( - surround inner word with (

#### airline plugin
git clone https://github.com/vim-airline/vim-airline ~/.vim/pack/dist/start/vim-airline
:helptags ~/.vim/pack/dist/start/vim-airline/doc

#### gruvbox
git clone https://github.com/morhetz/gruvbox.git ~/.vim/pack/default/start/gruvbox
vim ~/.vim/vimrc
<<CONTENT
colorscheme gruvbox
set background=dark
CONTENT

#### vifm 
brew install vifm
vifm
rm -rf ~/.config/vifm/colors
git clone https://github.com/vifm/vifm-colors ~/.config/vifm/colors
vim ~/.config/vifm/vifmrc
<<CONTENT
colorscheme gruvbox
nnoremap <C-e> :q<CR>
CONTENT
git clone https://github.com/vifm/vifm.vim ~/.vim/pack/default/start/vifm
:helptags ~/.vim/pack/default/start/vifm/doc

#### vim-tmux-navigator
git clone https://github.com/christoomey/vim-tmux-navigator.git ~/.vim/pack/default/start/vim-tmux-navigator
<<CONTENT
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"
bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l
CONTENT
tmux new -s mysession
tmux new -A -s mysession # attaches if exists
tmux attach -t mysession
tmux kill-session -t mysession
:new -s new-session
<Ctrl-b><Ctrl-s> - save session (uses session.vim)
<Ctrl-b>s - switch session
<Ctrl-b>c - create window in session
<Ctrl-b>n/p - next/previous window

#### spaceship
npm install -g spaceship-prompt

#### YouCompleteMe
sudo apt install python3-dev cmake
cd ~/.vim/pack/default/start
git clone https://github.com/ycm-core/YouCompleteMe YouCompleteMe
cd YouCompleteMe
git submodule update --init --recursive
python3 install.py --ts-completer
## --clangd-completer
## --all



#### plain text highlight (disabled)
git clone https://github.com/ZSaberLv0/ZFVimTxtHighlight ~/.vim/pack/zsaber/start/ZFVimTxtHighlight
:helptags ~/.vim/pack/zsaber/start/ZFVimTxtHighlight/doc

#### applescript syntax
git clone https://github.com/dearrrfish/vim-applescript ~/.vim

#### syntastic for eslint (disabled)
git clone https://github.com/vim-syntastic/syntastic.git ~/.vim/pack/syntastic/start/syntastic
:helptags ~/.vim/pack/syntastic/start/syntastic/doc

#.vimrc
<<CONTENT
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

:lopen - errors
:lwindow - open error window
CONTENT

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
