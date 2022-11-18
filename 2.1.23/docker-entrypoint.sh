#!/bin/sh
set -e

commandRun="run"
commandVersion="version"
commandCheck="check"
commandPlugin="check-plugin"
commandHelp="help"
commandValidate="validate"

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; Also check if the first argument is any
# of the KrakenD commands
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ] ||
   [ "$1" = "${commandRun}" ] || 
   [ "$1" = "${commandVersion}" ] || 
   [ "$1" = "${commandCheck}" ] || 
   [ "$1" = "${commandPlugin}" ] ||
   [ "$1" = "${commandValidate}" ] ||
   [ "$1" = "${commandHelp}" ]; then
    set -- krakend "$@"
fi

# check for the expected command
if [ "$1" = 'krakend' ]; then
    # use gosu (or su-exec) to drop to a non-root user
    exec su-exec krakend "$@"
fi

# else default to run whatever the user wanted like "bash" or "sh"
exec "$@"
