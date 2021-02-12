#!/bin/bash
#
# Attach or create tmux session named the same as current directory.
session_exists() {
    tmux ls | sed -E 's/:.*$//' | grep -q "^$session_name$"
}

not_in_tmux() {
    [ -z "$TMUX" ]
}

if [[ $PWD != $HOME ]]; then
    repo_name=$(find_up .git)
    session_name=$(basename "${repo_name:-$PWD}" | tr -d . | tr '[:upper:]' '[:lower:]')
else
    session_name=home
fi

if not_in_tmux; then
    tmux new-session -As "$session_name"
else
    if ! session_exists; then
        (TMUX='' tmux new-session -Ad -s "$session_name")
    fi
    tmux switch-client -t "$session_name"
fi
