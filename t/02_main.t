#!/usr/bin/perl -w

# Main testing for JSAN::Index::Data

use strict;
use lib ();
use UNIVERSAL 'isa';
use File::Spec::Functions ':ALL';
BEGIN {
	$| = 1;
	unless ( $ENV{HARNESS_ACTIVE} ) {
		require FindBin;
		chdir ($FindBin::Bin = $FindBin::Bin); # Avoid a warning
		lib->import( catdir( updir(), updir(), 'modules') );
	}
}

use JSAN::Index::Data;
use Test::More tests => 4;

# Does it provide anything
my @provides = JSAN::Index::Data->provides;
ok( scalar(@provides), 'JSAN::Index::Data provides at least one object type' );
@provides = JSAN::Index::Data->provides('DBI::db');
ok( scalar(@provides), 'JSAN::Index::Data provides a DBI::db object' );

# Does it actually return the connection?
my $dbh = JSAN::Index::Data->get('DBI::db');
TODO: {
	local $TODO = "Don't know how to get the file installed";
	ok( $dbh, "JSAN::Index::Data->get('DBI::db') returns something" );
	isa_ok( $dbh, 'DBI::db' );
}

exit(0);
