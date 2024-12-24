#!/bin/bash

URL="$1"

if [ -z "$URL" ]; then
    echo "No URL found in clipboard"
    exit 1
fi

HOST=$(echo "$URL" | cut -d/ -f3)

FILE_ID=$(curl "$URL" 2> /dev/null | grep -o "fileId: '.*'" | cut -d\' -f2)
MP4_URL=$(curl "https://$HOST/nws/recording/1.0/play/info/$FILE_ID?originDomain=$HOST" 2> /dev/null | grep -o 'viewMp4Url":"[^"]*' | cut -d\" -f3)

FILE_NAME=$(echo "$MP4_URL" | grep -Eo "GMT\d+")

echo "Saving to: $FILE_NAME.mp4"
echo 

curl "$MP4_URL" -H "Referer: https://$HOST/" --output "$FILE_NAME.mp4" 