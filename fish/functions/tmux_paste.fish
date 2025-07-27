function tmux_paste --description 'dump tmux buffer to fish cursor'
  # print tmux’s buffer 0 to variable
  set clip_cont $(tmux save-buffer -)
  #tmux save-buffer -
  # set variable as line content
  commandline -t -C 0
  commandline -i "$clip_cont"
end
