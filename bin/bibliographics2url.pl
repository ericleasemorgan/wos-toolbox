#!/usr/bin/env perl

# bibliographics2url.pl - given a TSV file, output URL pointing to PDF file

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 14, 2020 - first cut


# require
use strict;
use XML::XPath;

my $file = $ARGV[ 0 ];
my ( $doi, $header, $rdf ) = split( "\t", &slurp( $file ) );

	# extract the "canonical" link
	my $canonical = '';
	my @links     = split( ', ', $header );
	foreach my $link ( @links ) {

		# parse the link
		my @items = split( '; ', $link );
	
		# get the uri
		my $uri =  $items[ 0 ];
		$uri    =~ s/<//;
		$uri    =~ s/>//;
		
		# look for the canonical uri
		my $found = 0;
		for ( my $i = 1; $i < scalar( @items ); $i++ ) {
	
			# parse
			my ( $name, $value ) = split( '=', $items[ $i ] );
		
			# normalize/clean
			$value =~ s/"//g;
		
			# look for specific name/value pair; can look for other cool uri's here
			if ( $name eq 'type' and $value eq 'application/pdf' ) {
		
				# update and exit
				$canonical = $uri;
				$found     = 1;
				last;
			
			}
			
		}
	
		# don't do unnecessary work
		last if ( $found );
		
	}

	# extract the desired bibliographics
	if ( $rdf ) {

 		# re-initialize
 		my $rdf = XML::XPath->new( xml => $rdf ); 
		
		# parse; article title
		my $title_article =  $rdf->find( '/rdf:RDF/rdf:Description/j.0:title' )->string_value;
		$title_article    =~ s/'/''/g;

		# journal title
		my $title_journal =  $rdf->find( '/rdf:RDF/rdf:Description/j.0:isPartOf/j.2:Journal/j.0:title' )->string_value;
		$title_journal    =~ s/'/''/g;

		# date
		my $date =  $rdf->find( '/rdf:RDF/rdf:Description/j.0:date' )->string_value;
		$date    =~ s/'/''/g;

		# output, conditionally
		if ( $canonical )     { print "$canonical\n" }
		#if ( $canonical )     { print "UPDATE bibliographics SET url='$canonical' WHERE netid='netid' AND doi='$doi';\n\n" }
		#if ( $title_article ) { print "UPDATE bibliographics SET title_article='$title_article' WHERE netid='netid' AND doi='$doi';\n\n" }
		#if ( $title_journal ) { print "UPDATE bibliographics SET title_journal='$title_journal' WHERE netid='netid' AND doi='$doi';\n\n" }
		#if ( $date )          { print "UPDATE bibliographics SET date='$date' WHERE netid='netid' AND doi='$doi';\n\n" }
	   
	}
	



# read a file all at one go
sub slurp {

	my $f = shift;
	open ( F, $f ) or die "Can't open $f: $!\n";
	my $r = do { local $/; <F> };
	close F;
	return $r;

}