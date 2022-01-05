#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

for dir in */; do
    version="${dir/\//}" # Remove trailing slash
    docker build -t "krakend:$version" $dir
    docker run "krakend:$version" check -t -c krakend.json
done