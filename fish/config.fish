if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
  source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

function fish_user_key_bindings
  # first, install the stock vi key‐tables
  fish_vi_key_bindings

  # now bind our tmux helpers into the COMMAND mode table
  bind -M default 'yy' tmux_yank_line
  bind -M default 'dd' tmux_delete_line

  # and make sure 'p' in COMMAND mode pastes via fish_clipboard_paste
  bind -M default 'p' fish_clipboard_paste
end

