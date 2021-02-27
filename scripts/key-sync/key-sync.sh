#!/bin/bash

#
# It requires keepassxc and nextcloud or owncloud client already running
#

sync() {
    origin=$1

    destination=$([[ $origin == $cloud ]] && echo -n $keepass || echo -n $cloud)
    /usr/bin/rsync -a --delete $origin $destination
}

keepass=/home/xolotl/.keepassxc/
cloud=/home/xolotl/.nextcloud/.keepassxc/
events="-e create -e delete -e modify -e move"
file_pattern='.*\.kdbx\..+|#[0-9+]'
last_update=0

if /usr/bin/mkdir /tmp/key-sync.lock 2> /dev/null; then
    trap "rmdir /tmp/key-sync.lock 2> /dev/null; exit" INT TERM EXIT

    # notifications
    /usr/bin/notify-send "KeySync started" -i keysync
    echo "KeySync started"

    # check differences at startup
    # diff will return 0 (true) if there are not differences
    /usr/bin/diff $keepass $cloud > /dev/null || dirs=($(ls -td $keepass $cloud))
    [[ -n $dirs ]] && sync ${dirs[0]}

    # watcher
    exec -a keysync \
    /usr/bin/inotifywait --quiet --monitor --timefmt %s --format '%w %T' $events \
    --exclude $file_pattern -- $keepass $cloud | \
    while read mfile mtime; do
        if [[ $mtime -ge $last_update ]]; then
            sleep 1
            last_update=$(date +%s)
            sync $mfile
        fi
    done
    /usr/bin/rmdir /tmp/key-sync.lock
else
    pid=$(/usr/bin/pidof keysync)
    /usr/bin/notify-send "KeySync is already running with PID=$pid" -i keysync
    echo "Already running with PID=$pid"
fi
