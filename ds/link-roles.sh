#!/bin/sh
# Points a floor's roles.prompts collection at ds/roles/, so the job descriptions in git are the ones workers read.
# An edit to a role file reaches the next worker started or resumed in that role.
#
#   ds/link-roles.sh <project>      the floor's project name, as in ~/.tower/config.json
set -eu
project=${1:?usage: ds/link-roles.sh <project>}
root=$(dirname "${TOWER_CONFIG:-$HOME/.tower/config.json}")
roles=$(cd "$(dirname "$0")/roles" && pwd)
target="$root/collections/$project/roles.prompts"

if [ -e "$target" ] && [ ! -L "$target" ]; then
  echo "$target exists and is not a link: move its files into $roles first, then remove it." >&2
  exit 1
fi
mkdir -p "$root/collections/$project"
ln -sfn "$roles" "$target"
echo "$target -> $roles"
