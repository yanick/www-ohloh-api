use strict;
use warnings;

use Test::More;    # last test to print

use WWW::Ohloh::API;
use WWW::Ohloh::API::Messages;

plan skip_all => <<'END_MSG', 1 unless $ENV{OHLOH_KEY};
set the environment variable OHLOH_KEY to your api key to enable these tests
END_MSG

plan skip_all => <<'END_MSG', 1 unless $ENV{TEST_OHLOH_PROJECT};
set the environment variable TEST_OHLOH_PROJECT to enable these tests
END_MSG

plan tests => 1;

my $ohloh = WWW::Ohloh::API->new( api_key => $ENV{OHLOH_KEY}, );

my $messages = $ohloh->fetch_messages( project => $ENV{TEST_OHLOH_PROJECT} );

isa_ok $messages, 'WWW::Ohloh::API::Messages',
  '$messages is a W:O:A:Messages object';

print @_ while <$messages>;

