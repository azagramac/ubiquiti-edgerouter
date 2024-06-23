#! /bin/bash

# requeriments:
TOKEN="YOUR_TOKEN_BOT"
ID="YOUR_TOKEN_CHAT"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
DNS="1.1.1.1"
MSG="\xF0\x9F\x93\x8A LOG ROUTER WAN"
log=$(cat /var/log/messages | grep -i "WAN_IN-10-D" | awk -F "=" '{print $5}' | awk '{print $1}' | sort | uniq -c)

# Envio del mensaje
/usr/bin/ping -c2 $DNS > /dev/null 2>&1
if [ "$?" != 0 ]; then

        curl -s -X POST $URL \
        -d chat_id=$ID \
        -d parse_mode=HTML \
        -d text="$(printf "$MSG\n\xF0\x9F\x93\x8C LOG:<code>\n$log</code>")" \
                > /dev/null 2>&1
        exit 0
fi
