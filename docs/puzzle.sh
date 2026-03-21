#!/bin/sh
printf '\033c\033]0;%s\a' Elemental Twilight Puzzle
base_path="$(dirname "$(realpath "$0")")"
"$base_path/puzzle.x86_64" "$@"
