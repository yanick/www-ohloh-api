use strict;
use warnings;

use lib 't';

use Test::More tests => 1;    # last test to print

use FakeOhloh;
use Validators;

my $ohloh = Fake::Ohloh->new;

$ohloh->stash( 'yadah', 'messages.xml' );

my $messages = $ohloh->fetch_messages( account => 'Yanick' );

isa_ok $messages, 'WWW::Ohloh::API::Messages',
  'fetch_messages is a W:O:A:M object';

my @messages = $messages->all;

is @messages, 4, 'we have 4 messages';

