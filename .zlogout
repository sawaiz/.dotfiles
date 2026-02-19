#
# Executes commands at logout.
#

# Gracefully close the Apple Terminal window or tab when exiting the shell
if [[ "$OSTYPE" == darwin* && "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    osascript -e 'tell application "Terminal" to close (every window whose frontmost is true)' > /dev/null 2>&1
fi
