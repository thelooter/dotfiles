#!/bin/sh
# Store hook for `wl-paste --watch` (see extra/autostart.lua).
#
# cliphist has no notion of sensitive data -- there is not a single password/
# secret string in the binary -- so anything copied out of KeePassXC would land
# in ~/.cache/cliphist/db in plaintext and stay there for 750 entries. KeePassXC
# tags its own copies with the x-kde-passwordManagerHint MIME type, so drop
# those here and let everything else through. wl-paste feeds the selection on
# stdin; cliphist store reads it from there.
#
# Test for the *presence* of the type, not its value. KDE's convention is that
# the hint carries "secret" or "public", but the value does not survive a
# round-trip through this stack -- copying with the value "secret" and reading
# it straight back yields "public". Keying on the value would therefore store
# real passwords. Presence is also false-positive-free here: a plain wl-copy
# offers only text/plain, text/plain;charset=utf-8, TEXT, STRING, UTF8_STRING.
if wl-paste --list-types 2>/dev/null | grep -qx 'x-kde-passwordManagerHint'; then
    exit 0
fi

exec cliphist store
