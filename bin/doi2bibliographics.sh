#!/usr/bin/env bash

# doi2bibliographics.sh - a front-end to doi2bibliographics.pl
# usage: echo "select netid, doi from bibliographics;" | sqlite3 ./etc/library.db | parallel ./bin/doi2bibliographics.sh {}

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - first cut


# configure
IFS='|'
DOI2BIBLIOGRAPHICS='./bin/doi2bibliographics.pl'
TMP='./tmp'

# sanity check
if [[ -z "$1" ]]; then
	echo "Usage: $0 <doi> <directory>" >&2
	exit
fi

# parse
DOI="$1"
DIRECTORY=$2

# re-initialize
FILE="$DOI"	

# configure
FILE=$( echo $FILE | tr '.' '-' | tr '/' '_' )
OUTPUT="$DIRECTORY/$FILE.tsv"

# debug and do the work, conditionally
if [[ ! -f $OUTPUT ]]; then
	$DOI2BIBLIOGRAPHICS $DOI > $OUTPUT
fi

# finished
exit
