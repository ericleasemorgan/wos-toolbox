#!/usr/bin/env bash

# search.sh - given a few pre-configurations, query Web of Science and output batches of search results

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 14, 2020 - first investigations

# pre-configure
QUERY='AU=(Morgan EL)'

# configure
GETCOUNT='./bin/get-count.py'
RETRIEVE='./bin/retrieve.py'
OFFSET=1
COUNT=100
BATCH=0
TMP='./tmp'

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <output directory>" >&2
	exit
fi

# get input
DIRECTORY=$1

# initialize
RESULTS=$( $GETCOUNT "$QUERY" )
QUERYID=$( echo $RESULTS | cut -d ' ' -f1 )
TOTAL=$( echo $RESULTS | cut -d ' ' -f2 )
echo "              Query ID: $QUERYID" >&2
echo "  Total number of hits: $TOTAL"   >&2

# make sane
rm -rf $TMP
mkdir -p $TMP

# repeat forever; search
while [ 1 ]; do
	
	# re-configure
	let BATCH=BATCH+1
	OUTPUT=$TMP/batch-$( printf "%04d" $BATCH ).xml
		
	# do the work
	echo "Retrieving $COUNT records of $TOTAL starting at record $OFFSET ($OUTPUT)" >&2
	$RETRIEVE $QUERYID $OFFSET $COUNT > $OUTPUT
	
	break
	
	# increment and done, conditionally
	#let OFFSET=OFFSET+COUNT
	#if [[ $OFFSET -gt $TOTAL ]]; then break; fi
	#if [[ $OFFSET -gt $LIMIT ]]; then break; fi
	
# fini
done

exit

