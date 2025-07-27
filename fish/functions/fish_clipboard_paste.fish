function fish_clipboard_paste --description 'dump tmux buffer to stdout'
  # print tmux’s buffer 0 to variable
  tmux save-buffer -
end
