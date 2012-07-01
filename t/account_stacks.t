use strict;
use warnings;

use Test::More qw/ no_plan /;

use WWW::Ohloh::API::Test;
use Scalar::Util 'refaddr';

my $ohloh = WWW::Ohloh::API::Test->new( api_key => 'myapikey', debug => 0 );

$ohloh->stash_file( 
    'http://www.ohloh.net/accounts/12933/stacks.xml?page=1&v=1&api_key=myapikey'
        => 't/samples/account_stacks.xml' );

my $stacks = $ohloh->fetch( 'AccountStacks' => id => 12933 );

is $stacks->nbr_entries => 2;

my @stacks = $stacks->all;

is @stacks => 2;

my $stack = shift @stacks;

is $stack->id, '67997';
is $stack->title => 'Perl Stack';
is $stack->description => q{Perl stuff I'm using};

is $stack->account->id => $stack->account_id;

is $stack->updated_at => '2010-03-07T14:53:05';

is $stack->project_count => 20;

my @entries = $stack->all_entries;

is @entries => 95;

my $entry = shift @entries;

is $entry->id => 355195;
is $entry->stack_id => 67997;
is $entry->project_id => 5711;
is $entry->created_at => '2010-03-07T14:53:05';


