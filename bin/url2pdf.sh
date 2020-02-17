#!/usr/bin/env bash

URLS="$1"
DIRECTORY="$2"

I=0
cat $URLS | while read URL; do

	let I=I+1
	FILE=$DIRECTORY/article-$( printf "%04d" $I ).pdf
	
	echo "$URL" >&2
	echo "$FILE" >&2
	
	wget -T 3 -t 1 -O "$FILE" "$URL"
	
done
exit