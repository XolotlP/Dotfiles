#!/bin/bash

# For more info about shell colors see:
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

_section_has_content() {
    # if section has a prompt string or escaped text (with ;;) return true
    regex='[[:space:]]*\\[dhHjlstT@auvVwW!#][[:space:]]*+|;.+;'
    [[ $1 =~ $regex ]] && return 0

    _command=($(echo $1 | tr -d '\$\(\)'))
    if [[ ${_command[0]} == __git_ps1 ]]; then #check git branch info
        content=$(${_command[0]} 2> /dev/null)
    else #execute command with arguments
        content=$(${_command[*]} 2> /dev/null)
    fi

    # check if command returns info
    [[ -n $content ]] && return 0 || return 127
}

_colors() {
    foreground=$1 background=$2 formatter=$3

    [[ $formatter != *0* ]] && formatter="0;$formatter"
    if [[ $PROMPT_COLORS == 256 ]]; then
        # add escape secuences for 256 colors
        foreground="38;5;$foreground"
        background="48;5;$background"
    fi

    printf "%s" "\[\\e[$formatter;$foreground;${background}m\\]"
}

_separator() {
    separator_symbol=''
    formatter=$3

    background_color=$([[ $PROMPT_COLORS = 256 ]] && echo '' || echo 49)

    if [[ $PROMPT_COLORS == 256 ]]; then
        foreground_color=$([[ $formatter == *7* ]] && echo $1 || echo $2)
    else
        foreground_color=$([[ $formatter == *7* ]] && echo $1 || echo $(($2 - 10)))
    fi
    colors=$(_colors $foreground_color "$background_color" 0)

    printf "%s" "$colors$separator_symbol"
}

_section() {
    section=$1

    # if section has no significant prompt content do nothing more
    _section_has_content "$section" || return 127

    # eliminate scape characters from section's content
    local regex=';.*;'
    [[ $section =~ $regex ]] && section=$(sed -e "s/^;\(.*\);$/\1/" <<< $section)

    background_default=$([[ $PROMPT_COLORS == 256 ]] && echo "251" || echo "47")
    foreground_default=$([[ $PROMPT_COLORS == 256 ]] && echo "0" || echo "30")

    background_color=${2:-$background_default}          # defaults to light grey
    foreground_color=${3:-$foreground_default}          # defaults to black
    formatter=${4:-1}                   # I want bold text on my prompt

    colors=$(_colors $foreground_color $background_color $formatter)
    separator=$(_separator $foreground_color $background_color $formatter)

    printf "%s" "$colors$section$separator"
}

_update_last_section() {
    background_default=$([[ $PROMPT_COLORS == 256 ]] && echo "251" || echo "47")
    foreground_default=$([[ $PROMPT_COLORS == 256 ]] && echo "0" || echo "30")

    background=${2:-$background_default}          # defaults to light grey
    foreground=${3:-$foreground_default}          # defaults to black
    formatter=${4}

    if [[ $PROMPT_COLORS == 256 ]]; then
        new_color=$([[ $formatter == *7* ]] && echo $foreground || echo $background)
        local search='(.*;)(m.+.{4})$'
    else
        new_color=$([[ $formatter == *7* ]] && echo $((foreground + 10)) || echo $background)
        local search='(.*;)49(m.+.{4})$'
    fi

    local -n ref=$1 # pass by reference (note: pass var name not value)
    ref=$(sed -E -e "s/$search/\1$new_color\2/" <<< $ref)
}

_add_section() {
    prompt+="$(_section "$1" "$2" "$3" "$4")"
    _update_last_section prompt "$2" "$3" "$4"
}

_ps1_prompt() {
    prompt=''

    # example of usage
    # _add_section "section_content" "background_color" "foreground_color" "styles"
    # indicate current prompt user
    _add_section "$([ $USER == 'xolotl' ] && echo '; λ ;' || echo ' \u ')" 24 253
    # indicate current working directory
    _add_section ' 🖿 :\W ' $([[ $PROMPT_COLORS == 256 ]] && echo 39 || echo 104)
    # indicate git branch, if any
    _add_section ' $(__git_ps1 "⎇ :%s") ' $([[ $PROMPT_COLORS == 256 ]] && echo 2 || echo 102)

    prompt+='\[\e[0m\]'

    printf "%s " ${prompt@P}
}

_ps2_prompt() {
    colors=$([[ $PROMPT_COLORS == 256 ]] && echo '38;5;251' || echo '39;49')
    prompt="\[\e[0;${colors}m\]❙▶\[\e[0m\] "
    printf "%s " ${prompt@P}
}

case "$1" in
    PS1)
        _ps1_prompt
        ;;
    PS2)
        _ps2_prompt
        ;;
    *)
        ;;
esac
