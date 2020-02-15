#!/usr/bin/env bash

QUERY=$1
DIRECTORY=$2

rm -rf $DIRECTORY
mkdir -p $DIRECTORY
mkdir -p "$DIRECTORY/batches"
mkdir -p "$DIRECTORY/bibliographics"
mkdir -p "$DIRECTORY/pdf"

# search
echo "Searching" >&2
./bin/search-wos.py "$QUERY" "$DIRECTORY/batches"

# find each batch, extract the DOI, resolve the DOI, and save the resulting bibliographics
echo >&2
echo "Extracting bibliographics" >&2
#find "./$DIRECTORY/batches" -name "*.xml" | parallel ./bin/batch2doi.sh | parallel ./bin/doi2bibliographics.sh {} "$DIRECTORY/bibliographics"
find "./$DIRECTORY/batches" -name "*.xml" | parallel ./bin/batch2doi.sh | parallel ./bin/doi2bibliographics.sh {} "$DIRECTORY/bibliographics"

# find each bibliographic, extract the URL pointing to a PDF file, and save the result to a file
echo >&2
echo "Extracting URLs" >&2
find "./$DIRECTORY/bibliographics" -name *.tsv -exec ./bin/bibliographics2url.pl {} > "$DIRECTORY/urls.txt" \;
URLS=$( cat "$DIRECTORY/urls.txt" | sort )
echo "$URLS" > "$DIRECTORY/urls.txt"

# harvest pdf
echo >&2
echo "Harvesting" >&2
./bin/url2pdf.sh "$DIRECTORY/urls.txt" "$DIRECTORY/pdf"