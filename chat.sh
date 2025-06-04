#!/bin/bash

# Usage: ./chat.sh <your_name> <pipe_to_read> <pipe_to_write>

NAME="$1"
READ_PIPE="$2"
WRITE_PIPE="$3"

if [[ -z "$NAME" || -z "$READ_PIPE" || -z "$WRITE_PIPE" ]]; then
  echo "Usage: $0 <your_name> <pipe_to_read> <pipe_to_write>"
  exit 1
fi

# Trap Ctrl+C and exit cleanly
trap "echo -e '\nExiting...'; exit 0" SIGINT

# Background process to read messages
tail -f "$READ_PIPE" &
TAIL_PID=$!

# Read user input and send to write pipe
while true; do
  read -rp "$NAME: " MESSAGE
  echo "$NAME: $MESSAGE" > "$WRITE_PIPE"
done

# Cleanup
kill $TAIL_PID
