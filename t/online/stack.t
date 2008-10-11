use strict;
use warnings;
no warnings qw/ uninitialized /;

use Test::More;

use WWW::Ohloh::API;

plan skip_all => <<'END_MSG', 1 unless $ENV{OHLOH_KEY};
set OHLOH_KEY to your api key to enable these tests
END_MSG

unless ( $ENV{TEST_OHLOH_ACCOUNT} ) {
    plan skip_all => "set TEST_OHLOH_ACCOUNT to an account id "
      . "to enable these tests";
}

plan 'no_plan';

require 't/Validators.pm';

my $ohloh = WWW::Ohloh::API->new( api_key => $ENV{OHLOH_KEY} );

diag "using account $ENV{TEST_OHLOH_ACCOUNT}";

my $stack = $ohloh->fetch_account_stack( $ENV{TEST_OHLOH_ACCOUNT} );

validate_stack($stack);

