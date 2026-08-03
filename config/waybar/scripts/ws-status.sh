#!/usr/bin/env bash
# Prints waybar custom-module JSON for workspace $1: hides it if the
# workspace doesn't exist (no windows), highlights it if active.
n="$1"
ws_json=$(hyprctl workspaces -j)
active=$(hyprctl activeworkspace -j | jq -r '.id')
exists=$(jq -r --arg n "$n" '.[] | select(.id == ($n|tonumber)) | .id' <<< "$ws_json")

if [ -z "$exists" ]; then
    printf '{"text":"","class":"empty"}\n'
    exit 0
fi

if [ "$active" = "$n" ]; then
    class="active"
else
    class="inactive"
fi

printf '{"text":"%s","class":"%s"}\n' "$n" "$class"
