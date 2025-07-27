function fish_clipboard_paste --description 'dump tmux buffer to stdout'
  # print tmux’s buffer 0 to variable
  set clip_cont $(tmux save-buffer -)
  #tmux save-buffer -
  # set variable as line content
  commandline -t "$clip_cont"
end
