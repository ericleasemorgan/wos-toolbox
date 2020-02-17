#!/usr/bin/env python3

# search-wos.py - given a Web of Science query and a directory, output batches search results

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU License

# February 14, 2020 - first cut; the wos Python module is cool; "Thank you, Enrico Bacis!"


# configure
COUNT  = 100
OFFSET = 1
BATCH  = 0
#LIMIT  = 1000

# require
from wos import WosClient
import sys

# sanity check
if len( sys.argv ) != 3 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <query> <directory>\n" )
	exit()

# initialize
query     = sys.argv[ 1 ]
directory = sys.argv[ 2 ]

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
		file  = "batch-" + file + ".xml"
		file  = directory + '/' + file

		# search
		sys.stderr.write( "Retrieving %s records of %s starting at %s offset (%s)\n" % ( count, total, offset, file ) )
		results = client.retrieve( queryId, count=count, offset=offset )
				
		# save; easier with os-level redirection
		handle = open( file, 'w' ) 
		handle.write( results.records ) 
		handle.close() 
		
		# increment and done, conditionally		
		offset = offset + count
		if ( offset > total ) : break
		#if ( offset > LIMIT ) : break

# done
exit()