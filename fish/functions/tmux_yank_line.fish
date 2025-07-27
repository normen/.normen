function tmux_yank_line --description 'yank entire command‐line into tmux'
    # grab the entire commandline
    set -l line (commandline)
    # shove it (with a newline) into tmux buffer 0
    printf '%s\n' "$line" | tmux load-buffer -
    # optional: little on-screen ack
    #tmux display-message "YANK → $line"
end
