#!/bin/sh

########################################
# get title from PDF Services system
# ignore Automator settings

TITLE="${1:-}"
shift
shift

for f in "$@"
do
	FILE_CONTENT=$(base64 "$f")
	TMP_FILE=$(mktemp)
	echo '{"filename": "'"$TITLE"'.pdf","content": "'"$FILE_CONTENT"'"}' > $TMP_FILE
	########################################
	URL=$(curl -X POST -H "Content-Type: application/json" -d @$TMP_FILE -s https://api.multipost.com/api/printer | awk -v FS="(\":\"|\"})" '{print $2}' | sed 's/\\//g')
	open $URL
done