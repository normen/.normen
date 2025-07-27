function tmux_paste --description 'dump tmux buffer to fish cursor'
  # print tmux’s buffer 0 to variable
  set -l clip_cont $(tmux save-buffer -)
  set -l curPos (commandline -C)
  set -l newPos (math "$curPos + 1")
  # check if newPos is greater than the length of the commandline
  if test "$newPos" -gt (commandline | wc -m)
    # append content to the end of the commandline
    commandline -a "$clip_cont"
  else
    # insert content at the new position
    commandline -C "$newPos"
    commandline -i "$clip_cont"
  end
end
