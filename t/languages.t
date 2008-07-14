use strict;
use warnings;

use lib 't';

use Test::More tests => 4;    # last test to print
use Test::Exception;

use FakeOhloh;
use Validators;

my $ohloh = Fake::Ohloh->new;

$ohloh->stash( 'yadah', 'languages.xml' );

throws_ok { WWW::Ohloh::API::Languages->new } 'OIO::Args',
  'arg ohloh mandatory';

# by default, no max
ok !defined WWW::Ohloh::API::Languages->new( ohloh => $ohloh )->max,
  'by default, no max';

is( WWW::Ohloh::API::Languages->new( ohloh => $ohloh, max => 123 )->max =>
      123,
    'max argument'
);

my $langs = $ohloh->get_languages;

is $langs->total_entries, 32, 'total_entries()';

