#!/usr/bin/env python

# configure
NAME   = 'PY'
SORT   = 'D'

# require
from wos import WosClient
import sys

# sanity check
if len( sys.argv ) != 4 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <id> <offset> <count>\n" )
	exit()

# initialize
id         = sys.argv[ 1 ]
offset     = sys.argv[ 2 ]
count      = sys.argv[ 3 ]
client     = WosClient( close_on_exit=False )
parameters = client.make_retrieveParameters( name=NAME, sort=SORT )

# connect, do the work, and close
client.connect()
results = client.retrieve( id, count=count, offset=offset, retrieveParameters=parameters)

# output and done
print( results.records )
exit()