use strict;
use warnings;

use Test::More;

use WWW::Ohloh::API;

plan skip_all => <<'END_MSG', 1 unless $ENV{OHLOH_KEY};
set the environment variable OHLOH_KEY to your api key to enable these tests
END_MSG

unless ( $ENV{TEST_OHLOH_PROJECT} ) {
    plan skip_all => "set TEST_OHLOH_PROJECT to enable these tests";
}

plan tests => 1;

my $ohloh = WWW::Ohloh::API->new( api_key => $ENV{OHLOH_KEY} );

my $af = $ohloh->fetch_activity_facts( $ENV{TEST_OHLOH_PROJECT} );

my $facts = $af->latest;

pass;
