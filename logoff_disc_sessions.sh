#!/bin/bash

DISC_SESSIONS=$(/opt/Citrix/VDA/bin/ctxqfull | grep -i 'disc')

if [ -z "$DISC_SESSIONS" ]; then
    echo "No disconnected sessions found."
    exit 0
fi

while read -r line; do
    SESSION=$(echo "$line" | awk '{print $2}')

    /opt/Citrix/VDA/bin/ctxlogoff "$SESSION"
done <<< "$DISC_SESSIONS"
sleep 5

REMAINING_SESSIONS=$(/opt/Citrix/VDA/bin/ctxqfull | grep -i 'disc')

if [ -n "$REMAINING_SESSIONS" ]; then
    REMAINING_COUNT=$(echo "$REMAINING_SESSIONS" | wc -l)

    echo "Disconnected session logoff process complete, $REMAINING_COUNT session(s) still in disconnected state, please kill these manually."
    echo "Remaining sessions:"
    echo "$REMAINING_SESSIONS"
else
    echo "All disconnected sessions successfully logged off."
fi
