#!/usr/bin/env bash
# zj-pipe.sh — generic zjstatus pipe writer
#
# Usage: zj-pipe.sh <pipe-name> <message>
#   pipe-name: matches pipe_<name>_format defined in layouts/default.kdl
#   message:   display string to set (empty string clears the widget)
#
# This is the stable interface for all activity sources. If you later want
# a single-slot priority manager, change only this script — hook scripts
# and the zjstatus config stay untouched.

[ -z "$ZELLIJ_SESSION_NAME" ] && exit 0
zellij pipe -- "zjstatus::pipe::${1}::${2}" 2>/dev/null || true
