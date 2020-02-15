#!/usr/bin/env perl

# doi2bibliographics.pl - given doi, resolve the doi and output a TSV stream of bibliographics, sort of

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 14, 2020 - first cut


# configure
use constant RESOLVER => 'http://dx.doi.org';
use constant MIMETYPE => 'application/rdf+xml';

# require
use strict;
use LWP;

my $doi   = $ARGV[ 0 ];
if ( ! $doi ) { die "Usage: $0 <doi>\n" }

# initialize
my $useragent = LWP::UserAgent->new;
my $request   = HTTP::Request->new( GET => RESOLVER . "/$doi" );
$request->header( Accept => MIMETYPE );

# request the data
my $response = $useragent->request( $request );

# if success, parse the result
if ( $response->is_success ) {

	# get the link header; easy
	my $link = $response->headers->header( 'Link' );
	
	# get the content and unwrap it
	my $content =  $response->content;
	$content    =~ s/ +/ /g;
	$content    =~ s/\n+//g;
	$content    =~ s/> </></g;
	
	# output
	print join( "\t", ( $doi, $link, $content ) ) . "\n";
	
}

else { warn $response->content }

# done
exit;
