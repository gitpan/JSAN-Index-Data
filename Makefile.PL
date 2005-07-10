use inc::Module::Install;

name          ( 'JSAN-Index-Data'            );
abstract      ( 'A Data::Package for the SQLite JSAN Index');
author        ( 'Adam Kennedy <cpan@ali.as>' );
version_from  ( 'lib/JSAN/Index/Data.pm'     );
license       ( 'perl'                       );
requires      ( 'perl'            => '5.005' );
requires      ( 'File::Spec'      => '0.80'  );
requires      ( 'File::HomeDir'   => '0.05'  );
requires      ( 'Data::Package'   => '0.05'  );
requires      ( 'DBI'             => '1.43'  );
requires      ( 'DBD::SQLite'     => '1.00'  );
build_requires( 'Test::More'      => '0.47'  );

auto_install();
&WriteAll;
