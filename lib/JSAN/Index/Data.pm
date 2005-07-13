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
consume the data it provides. In this case L<JSAN::Index> and a range
of other JSAN-related packages.

=head1 STATUS

This distribution currently specificies the correct installation
dependencies, and implements the correct code.

It attempts to use the JSAN root path from the C<JSAN_PREFIX>
environment variable. If that does not exist, it will further guess that
the current user has a ~/.jsan directory.

Additional advice is sought on upgrading the Makefile.PL or this class
to get it downloaded and installed in a reliable place, and to update
the download as needed.

=head1 INSTALLING

In order to install this, you are going to need to have an existing
L<JSAN> index database. At time of writing, with JSAN at version 0.02,
this installs to $HOME/.jsan.index.sqlite

You may need to run the following before attempting to install this
package.

  cd ~
  mkdir .jsan
  cp .jsan.sqlite.index .jsan/index.sqlite

Hopefuly this will be resolved soon, and everything will play together
nicely. Give it time, JSAN is still young.

=head1 METHODS

This class implements the L<Data::Package> API, and provides data
in the form of a L<DBI::db> object (a database connection).

See the L<\SYNOPSIS> above for the standard use.

=cut

use strict;
use Carp          ();
use File::Spec    ();
use File::HomeDir ();
use DBI;
use base 'Data::Package';

use vars qw{$VERSION};
BEGIN {
	$VERSION = '0.02';
}

my @PATHS = File::Spec->catfile( File::HomeDir::home(), '.jsan' );
if ( $ENV{JSAN_PREFIX} ) {
	unshift @PATHS, $ENV{JSAN_PREFIX};
}

# Try to locate the index
my $ROOT = '';
my $FILE = '';
my $DSN  = '';
foreach my $path ( @PATHS ) {
	next unless -d $path;
	my $file = File::Spec->catfile( $path, 'index.sqlite' );
	unless ( -f $file ) {
		Carp::croak("Could not locate index.sqlite file inside JSAN path $path");
	}
	unless ( -r $file ) {
		Carp::croak("Do not have read permissions for JSAN index $file");
	}
	$ROOT = $path;
	$FILE = $file;
	$DSN  = "dbi:SQLite:dbname=$file";
}
unless ( $DSN ) {
	my $paths = join ', ', @PATHS;
	Carp::croak("Could not locate a JSAN path (tried $paths)");
}

=pod

=head2 dsn

The C<dsn> method provides direct access to the index database DSN

=cut

sub dsn { $DSN }

=pod

=head2 file

The C<file> method returns the file path for the SQLite index database

=cut

sub file { $FILE }

=pod

=head2 root

The C<root> method returns the JSAN root directory being used

=cut

sub root { $ROOT }





#####################################################################
# Param::Coerce Support

sub __as_DBI_db {
	my $dbh = DBI->connect( $DSN, '', '' );
	unless ( $dbh ) {
		Carp::croak("Database error connecting to JSAN index $DSN");
	}
	$dbh;
}

1;

=pod

=head1 TO DO

- Check this actually works with the real database

- Work out how to install to the correct place

- Implement the Data::Package::Update API once it exists

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
