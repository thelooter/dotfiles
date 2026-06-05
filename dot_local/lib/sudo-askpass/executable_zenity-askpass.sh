#!/usr/bin/env bash
# $1 is usually the prompt
prompt="${1:-Password:}"
exec zenity --password --title="Authentication required" --text="$prompt"
