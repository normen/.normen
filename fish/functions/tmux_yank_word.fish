function tmux_yank_word --description 'yank token from command‐line into tmux'
    # grab the current token
    set -l token (commandline -t)
    printf '%s' "$token" | tmux load-buffer -
    # optional: little on-screen ack
    #tmux display-message "YANK → $line"
end
