use strict;
use warnings;

use Test::More;

use WWW::Ohloh::API::Stack;

eval { require Test::Pod::Snippets; }
  or plan skip_all => 'test requires Test::Pod::Snippets';

my $has_TestGroup = eval "use Test::Group; 1";

plan tests => $has_TestGroup ? 1 : 44;

my $tps = Test::Pod::Snippets->new(
    verbatim  => 0,
    methods   => 1,
    functions => 0
);

$tps->runtest(
    module    => 'WWW::Ohloh::API::Stack',
    testgroup => $has_TestGroup
);
