use strict;
use warnings;

use Test::More tests => 1880;

use lib 't'; use FakeOhloh;
use Validators;

my $ohloh = Fake::Ohloh->new;

$ohloh->stash( 'yadah', 'stacks_project.xml' );

my @stacks = $ohloh->fetch_project_stacks(1234);

is scalar(@stacks), 4;

is scalar( map { $_->stack_entries } @stacks ), 309,
  'number of stack entries';

validate_stack($_) for @stacks;

