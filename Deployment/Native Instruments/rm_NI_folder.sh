#!/bin/sh

# Reaktor 6 and other products were showing as “Demo”, even though
# they should be licensed as part of Komplete 12 Ultimate

# To resolve, delete /Users/Shared/Native Instruments folder

# This forces re-read of all licenses.

# See: Native Instruments Support article
# https://support.native-instruments.com/hc/en-us/articles/360000848825

rm -R "/Users/Shared/Native Instruments"

exit 0
