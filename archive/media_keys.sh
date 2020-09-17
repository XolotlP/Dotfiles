#!/bin/bash

# auxiliar script to use when the multimedia key aren't working

# backlight control
_backligth() {
    [[ $1 == up || $1 == down ]] || return 127

    device=/sys/class/backlight/intel_backlight
    brightness=$(< $device/actual_brightness)
    maximum=$(< $device/max_brightness)
    delta=371

    if [[ $1 == up ]]; then
        ((brightness+=$delta))
        [[ $brightness -gt $maximum ]] && brightness=7500
    else
        ((brightness-=$delta))
        [[ $brightness -lt 0 ]] && brightness=0
    fi

    /usr/lib/gsd-backlight-helper $device $brightness
    return $?
}

_music_player() {
    controller=playerctl
    error_message="$controller not found in path, check if its installed"

    command -v $controller > /dev/null || (echo $error_message && return 127)

    case $1 in
        next )
            $controller next
            ;;
        previous )
            $controller previous
            ;;
        play-pause )
            $controller play-pause
            ;;
    esac
    return $?
}

_volumen() {
    controller=amixer
    error_message="$controller not found in path, check if its installed"

    command -v $controller > /dev/null || (echo $error_message && return 127)
    [[ $1 == up || $1 == down ]] || return 127

    scontrol=Master
    delta=${2:-6}

    if [[ $1 == up ]]; then
        amixer -q set $scontrol $delta%+
    else
        amixer -q set $scontrol $delta%-
    fi
    return $?
}

set -x
case $1 in
    0 )
        _backligth "up"
        ;;
    1 )
        _backligth "down"
        ;;
    2 )
        _music_player previous "play-pause"
        ;;
    3 )
        _music_player previous "previous"
        ;;
    4 )
        _music_player previous "next"
        ;;
    5 )
        _volumen "up"
        ;;
    6 )
        _volumen "down"
        ;;
    * )
        return 127
        ;;
esac
set +x
