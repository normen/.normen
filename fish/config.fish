if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
  source /usr/share/cachyos-fish-config/cachyos-config.fish
end

alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart='sudo systemctl restart'
alias log='sudo journalctl -f -u'
alias :e='vim'
alias :q=exit
alias öq=exit
alias wiki='vim -c VimwikiIndex'
alias bc='bc -l'
alias gst-list="gst-inspect-1.0 | fzf | awk '{print substr(\$2, 1, length(\$2)-1)}' | xargs gst-inspect-1.0"

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# initializes user key bindings, called by fish
function fish_user_key_bindings
  # first, install the stock vi key‐tables
  fish_vi_key_bindings
  # check if we are in TMUX
  if not set -q TMUX
    return
  end
  # now bind our tmux helpers into the COMMAND mode table
  bind -M default 'yy' tmux_yank_line
  bind -M default 'yw' tmux_yank_word
  bind -M visual 'y' tmux_yank_selection
  bind -M default 'dd' tmux_delete_line
  # and make sure 'p' in COMMAND mode pastes via fish_clipboard_paste
  bind -M default 'p' tmux_paste
  bind -M default 'P' tmux_paste_before
end

# secrets
if test -f ~/.secrets
  source ~/.secrets 2>/dev/null
end
# editor
set -gx EDITOR (which vim)
# find os type
set -l OSTYPE (uname -s | tr '[:upper:]' '[:lower:]')
# add own binaries to PATH
if not contains -- $HOME/.normen/bin/all $PATH
  set -pgx PATH $PATH $HOME/.normen/bin/all
end
# add bin paths based on os type
switch $OSTYPE
  case darwin
    if not contains -- $HOME/.normen/bin/macos $PATH
      set -pgx PATH $PATH $HOME/.normen/bin/macos
    end
  case linux
    if not contains -- $HOME/.normen/bin/linux $PATH
      set -pgx PATH $PATH $HOME/.normen/bin/linux
    end
  case dragonfly freebsd netbsd openbsd
    # no norms for these
  case '*'
    # catch-all for any other OS types
    # no norms for these
end
# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -pgx PATH ~/.local/bin
    end
end
# add profile
if test -f $HOME/.profile_fish
  source $HOME/.profile_fish
end
