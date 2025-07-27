function tmux_delete_line --description 'delete entire command‐line into tmux'
    set -l line (commandline)
    printf '%s\n' "$line" | tmux load-buffer -
    # clear the prompt
    commandline -r ''
    # optional: little on-screen ack
    #tmux display-message "DELETE → $line"
end
