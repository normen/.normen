function tmux_paste_before --description 'dump tmux buffer to fish cursor'
  # print tmux’s buffer 0 to variable
  set clip_cont $(tmux save-buffer -)
  # set variable as line content
  commandline -i "$clip_cont"
end
