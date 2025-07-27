function fish_clipboard_copy --description 'copy stdin into tmux buffer'
  # read from stdin and stuff it into tmux’s buffer 0
  tmux load-buffer -
end
