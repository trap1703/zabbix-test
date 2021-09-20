FILE=/var/log/messages
FILE1=/var/log/syslog
if test -f "$FILE"; then
    cat "$FILE" | wc -l
else
    cat "$FILE1" | wc -l
fi
