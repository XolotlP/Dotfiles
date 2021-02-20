#!/usr/bin/env bash

# unnamed sessions of tilda and any other terminal emulator
unnamed_sessions=$(tmux ls -F '#S' | sort -n | awk '/^(quick)?[0-9]+$/' | tr '\n' ' ')

# separate sessions
for session in $unnamed_sessions; do
    where="$(tmux showenv -t $session | xargs basename)"
    [[ $where == tilda ]] && tilda_sessions+="$session " || other_sessions+="$session "
done

# rename tilda sessions
prefix="quick"
tilda_index=0
for session in $tilda_sessions; do
    tmux rename-session -t $session "$prefix$tilda_index"
    ((tilda_index++))
done

## reindex unnamed sessions
new_index=0
for old_index in $other_sessions; do
  tmux rename-session -t $old_index $new_index
  ((new_index++))
done
