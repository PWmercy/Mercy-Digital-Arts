#!/bin/sh

wait_for_gui () {
    # Wait for the dock to determine the current user
    DOCK_STATUS=$(pgrep -x Dock)
    echo "Waiting for Desktop..."

    while [[ "$DOCK_STATUS" == "" ]]; do
        echo "Desktop is not loaded; waiting..."
        sleep 5
        DOCK_STATUS=$(pgrep -x Dock)
    done

		CURRENT_USER=$(/bin/echo "show State:/Users/ConsoleUser" | /usr/sbin/scutil | /usr/bin/awk '/Name :/&&!/loginwindow/{print $3}')
    echo "$CURRENT_USER is logged in and at the desktop; continuing."
}

wait_for_gui

idleTime=$(/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')
echo Idle Time is "$idleTime" seconds
  # if (( idleTime > 900 )); then
	# pkill loginwindow
# fi
exit 0
