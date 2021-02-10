#!/bin/bash

_read_config() {
    case $PROMPT_COLORS in
        '' | 16 | 256 )
            PROMPT_SCRIPT=${BASH_SOURCE%".sh"}-build.sh
            ;;
        * )
            echo "Error: Invalid PROMPT_COLORS value"
            return 127
            ;;
    esac
    # if enabled always draw prompt at the begginig of the line, it uses return
    # carriage '\r' so any message before the prompt it is ready will be overwriten
    if [[ -n $PROMPT_ALWAYS_BOL && $PROMPT_ALWAYS_BOL != 0 ]]; then
        PROMPT_COMMAND='printf "%b" "\r"'
    fi
}

_generate_prompt() {
    # pass variable by reference (note: pass variable name not its value)
    local -n prompt=${1:-PS1}

    # source script in the subshell so it can have access to your other sourced
    # scripts, e.g. the 'git-prompt' script to get info about your current repo
    prompt='$(\. $PROMPT_SCRIPT '${1}')'
}

## UNCOMMENT LINE TO ABILITATE OPTION
## Use 256 colors terminal
PROMPT_COLORS=256
## Always start prompt at begginig of line
# PROMPT_ALWAYS_BOL=1

## Unstaged (*) and Staged (+) changes will be shown next to the branch name
# GIT_PS1_SHOWDIRTYSTATE=1
## See if currently something is stashed ($)
# GIT_PS1_SHOWSTASHSTATE=1
## See if there're untracked files (%)
# GIT_PS1_SHOWUNTRACKEDFILES=1
## See the difference between HEAD and its upstream:
## behind (<), ahead (>), diverged (<>), no difference (=)
# GIT_PS1_SHOWUPSTREAM="auto"
# Change the separator between the branch name and the above state symbols
# GIT_PS1_STATESEPARATOR=":"
# __git_ps1 will do nothing if the current directory is set up to be git ignored
GIT_PS1_HIDE_IF_PWD_IGNORED=1

if _read_config; then
    _generate_prompt PS1
    _generate_prompt PS2
else
    # default prompt (left here just in case)
    PS1='\u:\W$(__git_ps1 "(%s)")☯ '
fi

# don't overload the shell
unset _read_config
unset _generate_prompt
