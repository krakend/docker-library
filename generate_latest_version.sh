#!/usr/bin/env bash

set -Eeuo pipefail

VERSION=$(curl -sL https://github.com/taik0/krakend-ce/releases | \
        grep -o 'releases/tag/v[0-9]*.[0-9]*.[0-9]*' | sort -V | \
        tail -1 | awk -F'/' '{ print $3}')


curl -sLo checksums.txt https://github.com/taik0/krakend-ce/releases/download/${VERSION}/checksums.txt
amd64checksum=$(grep amd64_alpine.tar.gz checksums.txt | awk '{print $1}')
arm64checksum=$(grep arm64_alpine.tar.gz checksums.txt | awk '{print $1}')
rm -f checksums.txt

ALPINE_VERSION=$(curl -sL https://raw.githubusercontent.com/taik0/krakend-ce/${VERSION}/Makefile | \
                grep -m 1 ALPINE_VERSION | sed 's/^.*= //g')

OUTPUT=$(cat <<EOF 
"${VERSION:1}": {
    "alpine": "${ALPINE_VERSION}",
    "sha512sum_amd64": "${amd64checksum}",
    "sha512sum_arm64": "${arm64checksum}",
    "config_version": 3
}
EOF
)

current_versions=$(cat versions.json)
echo ${current_versions} | jq ". += {${OUTPUT}}" | tee versions.json
