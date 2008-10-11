use strict;
use warnings;

use Test::More;    # last test to print

use WWW::Ohloh::API;
use WWW::Ohloh::API::Messages;

plan skip_all => <<'END_MSG', 1 unless $ENV{OHLOH_KEY};
set the environment variable OHLOH_KEY to your api key to enable these tests
END_MSG

plan tests => 1;

my $ohloh = WWW::Ohloh::API->new( api_key => $ENV{OHLOH_KEY}, );

my $messages = WWW::Ohloh::API::Messages->new(
    ohloh   => $ohloh,
    account => 'Yanick'
);

isa_ok $messages, 'WWW::Ohloh::API::Messages',
  '$messages is a W:O:A:Messages object';

print @_ while <$messages>;
