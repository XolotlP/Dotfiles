#!/usr/bin/env bash

# tilda sessions
for session in $(tmux ls -F '#S' | sort -g); do
    tmux showenv -t $session | grep tilda > /dev/null && \
    tilda_sessions+="$session "
done
# rename tilda sessions
prefix="quick"
tilda_index=0
for session in $tilda_sessions; do
    tmux rename-session -t $session "$prefix$tilda_index"
    ((tilda_index++))
done

## reindex unnamed sessions
unnamed_sessions=$(tmux ls -F '#S' | sort -n | awk '/^[0-9]+$/' | tr '\n' ' ')
new_index=0
for old_index in $unnamed_sessions; do
  tmux rename-session -t $old_index $new_index
  ((new_index++))
done
