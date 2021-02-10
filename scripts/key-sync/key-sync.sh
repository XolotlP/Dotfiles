#!/bin/bash

#
# It requires keepassxc and nextcloud or owncloud client already running
#

sync() {
    origin=$1 dir_a=$2 dir_b=$3

    if [[ $origin == $dir_a ]]; then
        rsync -a --delete $dir_a $dir_b
    else
        rsync -a --delete $dir_b $dir_a
    fi
}

keepass=/home/xolotl/.keepassxc/
cloud=/home/xolotl/.nextcloud/.keepassxc/
options="-q -m -e create -e delete -e modify -e move"
pattern='.*\.kdbx\..+|#[0-9+]'
last_update=0

if mkdir /tmp/key-sync.lock 2> /dev/null; then
    trap "rmdir /tmp/key-sync.lock 2> /dev/null; exit" INT TERM EXIT
    notify-send "KeySync started" -i keysync
    echo "KeySync started"

    # it will only update databases when databases are in process of editing, it
    # will not work if you are trying sync databases when keepassxc or nextcloud
    # are not already running
    exec -a keysync \
    inotifywait $options --format '%w %T' --timefmt %s --exclude $pattern $keepass $cloud | \
    while read file mtime; do
        if [[ $mtime -ge $last_update ]]; then
            sleep 1
            last_update=$(date +%s)
            sync $file $keepass $cloud
        fi
    done
    rmdir /tmp/key-sync.lock
else
    pid=$(pidof keysync)
    notify-send "KeySync is already running with PID=$pid" -i keysync
    echo "Already running with PID=$pid"
fi
