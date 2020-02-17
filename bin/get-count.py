#!/usr/bin/env python

# get-count.py = given a query, search Web of Science, and output a query id as well as number of records FOUND_IT

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNP License

# February 14, 2020 - first cut; based on ln-toolbox code


# configure
COUNT = 0

# require
from wos import WosClient
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <query>\n" )
	exit()

# initialize
query  = sys.argv[ 1 ]
client = WosClient( close_on_exit=False )
 
# connect, search, and close
client.connect()
results = client.search( query, count=COUNT,)

# output, and done
print( " ".join( [ str( results.queryId ), str( results.recordsFound ) ] ) )
exit()