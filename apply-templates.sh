#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"
template="Dockerfile.template"

# Dependencies:
type jq >/dev/null 2>&1 || { echo >&2 "Install 'jq' before running this script."; exit 1; }
[ -f versions.json ] || { echo >&2 "The versions.json file does not exist"; exit 1; }

generated_warning() {
	cat <<-EOH
		#
		# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
		#
		# PLEASE DO NOT EDIT IT DIRECTLY.
		#
	EOH
}

replace_variables() # Args: $var $value $file
{
    # Escape problematic character for sed:
    var_content="$(echo $2 | sed -e 's/[\/&]/\\&/g')"
    # Replace @@VARS@@ with its desired value:
    sed -i "s#@@${1}@@#${var_content}#" "$3"
    echo "[OK] Var @@$1@@ written"
}

check_missing_vars() #Args: $dockerfile
{
    # Check if there is any remaining variable for substitution:
    MISSING_ENV_VARS="$(grep @@ $1 || true)"
    if [ "x$MISSING_ENV_VARS" = 'x' ]; then
        echo "[OK] All variables replaced in $1"
    else
        echo "[FAIL] There are still VARS pending to replace in $1:"
        echo "$MISSING_ENV_VARS"
        exit 1
    fi
}

# List of all versions available e.g.: "1.4.1 1.4.0 1.3.0"
versions="$(jq -r 'keys | join(" ")' versions.json)"

# Create Dockerfile for each version
for version in $versions; do
    mkdir -p "$version"
    dockerfile="$version/Dockerfile"
    echo "Writing Dockerfile for $version"
    {
        generated_warning
        cat Dockerfile.template
    } > "$dockerfile"

    # Replace @@variables@@ with content in JSON file:
    replace_variables "version" "$version" "$dockerfile"

    filter="jq -r '.[\"${version}\"] | keys | join(\" \")' versions.json"
    replacement_variables=$(eval $filter)
    for var in $replacement_variables; do
        filter_value="jq -r '.[\"${version}\"].$var' versions.json"
        value=$(eval $filter_value)
        replace_variables "$var" "$value" "$dockerfile"
    done

    check_missing_vars "$dockerfile"

done