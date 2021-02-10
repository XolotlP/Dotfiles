source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# Default command to use when input is tty
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'

# Default options
export FZF_DEFAULT_OPTS="\
--tiebreak=length,begin,end,index \
--multi \
--no-mouse \
--height=100% \
--info=hidden \
--tabstop=4 \
--prompt='>> ' \
--color='bg+:236,hl:39,hl+:39,prompt:39,pointer:2,marker:3' \
"

## Shell integration (BASH)
##------------------------------------------------------------------------------
# CTRL-T (Paste the selected files and directories onto the command-line )
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--layout=reverse --select-1 --exit-0'

# CTRL-R
export FZF_CTRL_R_OPTS="$FZF_CTRL_T_OPTS"

# ALT-C (cd into the the selected directory)
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="$FZF_CTRL_T_OPTS"

## Autocompletion in prompt (e.g. vim **<tab>)
##------------------------------------------------------------------------------
# Use fd  instead of the default find to list path candidates.
_fzf_compgen_path() {
  fd --hidden --follow --exclude .git --ignore-file ~/.gitignore . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git . "$1"
}
