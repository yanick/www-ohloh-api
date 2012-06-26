use strict;
use warnings;

use Test::More tests => 3;

use WWW::Ohloh::API;

my $ohloh = WWW::Ohloh::API->new;

ok $ohloh, 'object creation';

$ohloh->set_api_key('mykey');

is $ohloh->api_key => 'mykey', 'set/get_api_key';

$ohloh = WWW::Ohloh::API->new( api_key => 'myotherkey' );

is $ohloh->api_key => 'myotherkey', 'set api key from new()';

