#! /bin/bash

# requeriments:
TOKEN="YOUR_TOKEN_BOT"
ID="YOUR_TOKEN_CHAT"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
DNS="1.1.1.1"
ABUSEIPDB_KEY="ABUSEIPDB_KEY"
MSG="\xF0\x9F\x93\x8A LOG ROUTER WAN"
IPS=$(cat /var/log/messages | grep -i "WAN_IN-20-D" | awk -F "=" '{print $5}' | awk '{print $1}' | sort -u)

# Consulta con abuseipdb
for IP in $IPS; do
  log="$log $(curl -s -G "https://api.abuseipdb.com/api/v2/check" --data-urlencode "ipAddress=$IP" -d "maxAgeInDays=90" -d "verbose" -H "Key: $ABUSEIPDB_KEY" -H "Accept: application/json" | sed -n 's/.*"ipAddress":"\([^"]*\)".*"abuseConfidenceScore":\([^,]*\).*"countryCode":\([^,]*\).*"usageType":"\([^"]*\)".*"isp":\([^,]*\).*"domain":"\([^"]*\)".*"countryName":"\([^"]*\)".*/\n\1\n\t\t- abuseConfidenceScore: \2\n\t\t- countryCode: \3\n\t\t- usageType: \4\n\t\t- isp: \5\n\t\t- domain: \6\n\t\t- countryName: \7/p')"
done

# Envio del mensaje
/usr/bin/ping -c2 $DNS > /dev/null 2>&1
if [ "$?" != 0 ]; then
        exit 0
else
  curl -s -X POST $URL \
    -d chat_id=$ID \
    -d parse_mode=HTML \
    -d text="$(printf "$MSG\n\xF0\x9F\x93\x8C LOG:<code>\n$log</code>")"
  exit 0
fi