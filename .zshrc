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
alias wiki='vim -c VimwikiIndex'

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

# Use menu for completion, don't ask
zstyle ':completion:*' menu yes select

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

# copy-paste to tmux
function tmux-clip-wrap-widgets() {
    # NB: Assume we are the first wrapper and that we only wrap native widgets
    # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
    local copy_or_paste=$1
    shift
    for widget in $@; do
        # Ugh, zsh doesn't have closures
        if [[ $copy_or_paste == "copy" ]]; then
            eval "
            function _tmux-clip-wrapped-$widget() {
                zle .$widget
                tmux load-buffer - <<<\$CUTBUFFER
            }
            "
        else
            eval "
            function _tmux-clip-wrapped-$widget() {
                CUTBUFFER=\$(tmux save-buffer -)
                zle .$widget
            }
            "
        fi
        zle -N $widget _tmux-clip-wrapped-$widget
    done
}
local copy_widgets=(
    vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
)
local paste_widgets=(
    vi-put-{before,after}
)
# NB: can atm. only wrap native widgets
if [ -n "$TMUX" ]; then
  tmux-clip-wrap-widgets copy $copy_widgets
  tmux-clip-wrap-widgets paste  $paste_widgets
fi

# add own bin directory to path
case "$OSTYPE" in
  darwin*)
    export PATH=$PATH:$HOME/.normen/osx/scripts
  ;;
  linux*)
    export PATH=$PATH:$HOME/.normen/bin/raspi
  ;;
  dragonfly*|freebsd*|netbsd*|openbsd*)
  ;;
esac

# add go bin
if [ -d "$HOME/go" ]; then
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
fi

# tab for autosuggest
bindkey '^I' autosuggest-accept
# ctrl-space for complete
bindkey '^ ' expand-or-complete

# antigen plugins settings
ADOTDIR=$HOME/.normen/.antigen
SPACESHIP_ROOT=$HOME/.normen/.antigen/bundles/denysdovhan/spaceship-prompt
ZSH_AUTOSUGGEST_USE_ASYNC=true

# load antigen plugins
source $HOME/.normen/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme denysdovhan/spaceship-prompt
antigen apply

