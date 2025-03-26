#!/bin/sh
set -eu

# this if will check if the first argument is nonexistent or a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; Also check if the first argument is any
# of the KrakenD commands
case "${1:-}" in
	''            | \
	-*            | \
	run           | \
	version       | \
	check         | \
	check-plugin  | \
    test-plugin   | \
	validate      | \
	audit         | \
	help          )
		set -- krakend "$@"
		;;
esac

# check for the expected command
if [ "$1" = 'krakend' ]; then
    # krakend user has uid 1000
    # https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
    # runAsUser: 1000
    if [ "$(id -u)" = 0 ]; then
        # use su-exec to drop to a non-root user
        exec su-exec krakend "$@"
    else
        exec "$@"
    fi
fi

# else default to run whatever the user wanted like "bash" or "sh"
exec "$@"
