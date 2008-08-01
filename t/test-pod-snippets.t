use strict;
use warnings;

use Test::More tests => 1;    # last test to print

use Test::Pod::Snippets;

my $tps = Test::Pod::Snippets->new( verbatim => 0, methods => 1 );

$tps->runtest('lib/WWW/Ohloh/API/Stack.pm');
