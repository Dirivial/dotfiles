#!/bin/sh


function printSessions() {
    echo ""
    echo "---- Sessions ----"
    echo ""
    echo "  Create: tmux new"
    echo "  Create: tmux new -s <name>"
    echo "  View: C-a + s"
    echo "  Rename: C-a + $"
    echo "  Kill: tmux kill-session -t <name>"
}

function printWindows() {
    echo ""
    echo "---- Windows ----"
    echo ""
    echo "  View: C-a + w"
    echo "  Rename: C-a + ,"
    echo "  Kill: C-d"
}

function printCopyMode() {
    echo ""
    echo "---- Copy Mode ----"
    echo ""
    echo "  Enter: C-a + ["
    echo "  Start copy: Space"
    echo "  Copy: Enter"
    echo "  Paste: C-a + ]"
}

printSessions
printWindows
printCopyMode
