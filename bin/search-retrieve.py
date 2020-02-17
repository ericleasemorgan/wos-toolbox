#!/usr/bin/env python

# pre-configure
QUERY     = 'AU=(morgan el)'
DIRECTORY = '/Users/emorgan/Desktop/results'

# configure
COUNT  = 100
OFFSET = 1
BATCH  = 0

# require
from wos import WosClient
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <query>\n" )
	exit()

# initialize
query  = sys.argv[ 1 ]
query  = QUERY

# search/retrieve
with WosClient() as client :

	# get metadata
	metadata = client.search( query, count=0 )

	# parse and debug
	queryId = metadata.queryId
	total   = metadata.recordsFound
	sys.stderr.write( "                query id: " + str( queryId ) + "\n" )
	sys.stderr.write( " total number of records: " + str( total )   + "\n" )

	# initialize some more
	count  = COUNT
	offset = OFFSET
	batch  = BATCH
	
	# retrieve, forever
	while True :

		# configure output
		batch = batch + 1
		file  = '%03d' % batch
		file  = "records-" + file + ".xml"
		file  = DIRECTORY + '/' + file

		# search
		sys.stderr.write( "Retrieving count records of total starting at record offset (file)\n" )
		results = client.retrieve( queryId, count=count, offset=offset )

		# save; easier with os-level redirection
		handle = open( file, 'w' ) 
		handle.write( results.records ) 
		handle.close() 
		
		# increment and done, conditionally		
		offset = offset + count
		if ( offset > total ) : break

# done
exit()