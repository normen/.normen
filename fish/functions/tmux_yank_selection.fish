function tmux_yank_selection --description 'yank word from command‐line into tmux'
    # grab the selection
    set -l line (commandline -s)
    # shove it into tmux buffer 0
    printf '%s' "$line" | tmux load-buffer -
    # optional: little on-screen ack
    #tmux display-message "YANK → $line"
end
