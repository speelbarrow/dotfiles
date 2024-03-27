#!/bin/sh

FOUND_CHANGES=0
MESSAGE=""

while read line; do
        if [ $FOUND_CHANGES -eq 0 ]; then
                if echo $line | grep -q "# Changes to be committed:"; then
                        FOUND_CHANGES=1
                fi
                continue
        elif [ $FOUND_CHANGES -eq 1 ] && echo $line | grep -q "^#$"; then
                break
        fi

        if [ "$MESSAGE" != "" ]; then
                MESSAGE="$MESSAGE\n\n"
        fi

        MESSAGE="$MESSAGE$(echo "$line" | sed 's/^#\t\(.*\)$/\1/')"
done < $1
echo "$MESSAGE$(cat $1)" > $1
