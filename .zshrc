alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart='sudo systemctl restart'
alias log='sudo journalctl -f -u'
alias :e='vim'
alias :q=exit
alias öq=exit
alias la='ls -A'
alias ll='la -alF'
alias l='ls -CF'
alias mv='mv -i'
alias rm='rm -i'
alias wiki='vim -c VimwikiIndex'
alias bc=bc -l

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

# allow comments in shell
set -k

# Use vi keybindings
bindkey -v

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use menu for completion, don't ask
zstyle ':completion:*' menu yes select

# make ls colors work on linux and OSX/BSD
if whence dircolors >/dev/null; then
  eval "$(dircolors -b)"
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  alias ls='ls --color'
else
  export CLICOLOR=1
  zstyle ':completion:*:default' list-colors ''
fi

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
export PATH=$PATH:$HOME/.normen/bin/all
case "$OSTYPE" in
  darwin*)
    export PATH=$PATH:$HOME/.normen/bin/macos
  ;;
  linux*)
    export PATH=$PATH:$HOME/.normen/bin/linux
  ;;
  dragonfly*|freebsd*|netbsd*|openbsd*)
  ;;
esac

# add go bin
#if [ -d "$HOME/go" ]; then
#  export GOPATH=$HOME/go
#  export PATH=$PATH:$GOPATH/bin
#fi

# source .profile if exists
if [ -f "$HOME/.profile" ]; then
  source $HOME/.profile
fi

# tab for autosuggest
bindkey '^I' autosuggest-accept
# ctrl-space for complete
bindkey '^ ' expand-or-complete

# antigen plugins settings
ADOTDIR=$HOME/.normen/.antigen
SPACESHIP_ROOT=$HOME/.normen/.antigen/bundles/spaceship-prompt/spaceship-prompt
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=true
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# load antigen plugins
source $HOME/.normen/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme spaceship-prompt/spaceship-prompt
antigen apply

# fix mode indicator
eval spaceship_vi_mode_enable

# ai completion..
create_ai_completion() {
  text=${BUFFER}
  if [[ $text = \#* ]] ; then
    secret_key=$(cat ~/.config/openaiapirc | sed -n -e 's/^secret_key *= *\(.*\)$/\1/p')
    promp="# This converts text to single line shell commands.\n\n# list all files in current directory\nls -p | grep -v\n# new tmux session named hurz\ntmux new -s hurz\n# unpack myfile.tar.gz\ntar -xvzf myfile.tar.gz\n# list all docker containers\ndocker ps -a\n# initialize git repository and add all files\ngit init && git add -a\n${BUFFER}\n"
    completion=$(curl -s https://api.openai.com/v1/engines/davinci-codex/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ${secret_key}" \
      -d "{ \"prompt\": \"${promp}\", \"stop\": [\"#\"], \"max_tokens\": 100 }" \
      | sed -n -e 's/.*"text": *"\([^"]*\)".*/\1/p' \
      | sed 's/\\n/\n/g'
    )
    secret_key=""
    BUFFER="${text}
${completion}"
    CURSOR=${#BUFFER}
  fi
}
zle -N create_ai_completion
bindkey '^X' create_ai_completion
