package JSAN::Index::Data;

=pod

=head1 NAME

JSAN::Index::Data - A Data::Package for the SQLite JSAN Index

=head1 SYNOPSIS

  # Load the data package
  use JSAN::Indexer:Data;
  
  # Request the data it manages
  my $dbh = JSAN::Indexer::Data->get('DBI::db');

=head1 DESCRIPTION

This is the distribution and package for the JSAN index.

JSAN is the JavaScript Archive Network and can be located at
L<http://openjsan.org/>.

C<JSAN::Indexer::Data> is a L<Data::Package>, a package with the
sole purpose of integrating a "data product" into the CPAN namespace,
abstracting away and encapsulating the implementation complexity so
that all you need to do is request a the data from the class.

It is versioned and installed separately from the things that will
consume the data it provides. In this case L<JSAN::Index>.

=head1 STATUS

This distribution currently specificies the correct installation
dependencies, and implements the correct code. However, I'm unsure
how to actually control the installation location for the JSAN index.

Advice is sought on upgrading the Makefile.PL or this class to get
it downloaded and installed in a reliable place, and to update the
download as needed.

=head1 METHODS

This class implements the L<Data::Package> API, and provides data
in the form of a L<DBI::db> object (a database connection).

See the L<\SYNOPSIS> above for the standard use.

=cut

use strict;
use File::Spec    ();
use File::HomeDir ();
use DBI;
use base 'Data::Package';

use vars qw{$VERSION $DSN};
BEGIN {
	$VERSION = '0.01_01';
	$DSN     = '';
}

# Assume a default location until someone tells us better.
my $FILE = File::Spec->catfile( File::HomeDir::home(), '.jsan', 'index.db' );
$DSN = "dbi:SQLite:$FILE" if -f $FILE;

# Provide and get implemented using the coerce mechanism
sub __as_DBI_db {
	my $either = shift;
	return undef unless $DSN;

	# Connect to the database
	my $dbh = DBI->connect( $DSN, '', '' );

	# Handle DBI connect errors (just return undef for now)
	unless ( $dbh ) {
		return undef;
	}

	$dbh;
}

1;

=pod

=head1 TO DO

- Check this actually works with the real database

- Work out how to install to the correct place

- Implement the Data::Package::Upgrade API once it exists

=head1 SUPPORT

Bugs should be reported via the CPAN bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=JSAN-Index-Data>

For other issues, contact the author.

=head1 AUTHOR

Adam Kennedy E<lt>cpan@ali.asE<gt>, L<http://ali.as/>

=head1 COPYRIGHT

Copyright 2005 Adam Kennedy. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
