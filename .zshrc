fpath=($fpath ~/.zfunctions)
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart='sudo systemctl restart'
alias log='sudo journalctl -f -u'
alias :e='vim'
alias :q=exit
alias la='ls -A'
alias ll='la -alF'
alias l='ls -CF'
alias mv='mv -i'
alias rm='rm -i'

# Make <Esc> quicker
export KEYTIMEOUT=1

# Fix vifm colorschemes
export TERM=xterm-256color
# Fix for tmux
if [[ -n ${TMUX} && -n ${commands[tmux]} ]];then
      TERM=screen-256color
fi

setopt histignorealldups #sharehistory

# use paths as cd command
setopt -S autocd

# Use vi keybindings
bindkey -v

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# make ls colors work on linux and OSX/BSD
if whence dircolors >/dev/null; then
  eval "$(dircolors -b)"
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  alias ls='ls --color'
else
  export CLICOLOR=1
  zstyle ':completion:*:default' list-colors ''
fi
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

autoload -Uz compinit
compinit

# color man pages
man() {
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}

# normal mode by default (causes issues)
#function zle-line-init {
#  zle -K vicmd
#  zle reset-prompt
#}
#zle -N zle-line-init

# apparently fixes spaceship's mode detection as well
function zle-keymap-select {
  zle reset-prompt
}
zle -N zle-keymap-select

# set EDITOR
export EDITOR=$(which vim)

# Set up the prompt
autoload -Uz promptinit
promptinit
prompt spaceship

