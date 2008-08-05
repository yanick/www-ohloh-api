use strict;
use warnings;

use Test::More tests => 1;    # last test to print

use Test::Pod::Snippets;

use WWW::Ohloh::API::Stack;

my $tps = Test::Pod::Snippets->new(
    verbatim  => 0,
    methods   => 1,
    functions => 0
);

$tps->runtest( module => 'WWW::Ohloh::API::Stack', testgroup => 1 );
