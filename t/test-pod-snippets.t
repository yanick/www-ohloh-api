use strict;
use warnings;

use Test::More;

use WWW::Ohloh::API::Stack;

eval { require Test::Pod::Snippets; }
  or plan skip_all => 'test requires Test::Pod::Snippets';

plan tests => 1;

my $tps = Test::Pod::Snippets->new(
    verbatim  => 0,
    methods   => 1,
    functions => 0
);

$tps->runtest( module => 'WWW::Ohloh::API::Stack', testgroup => 1 );
