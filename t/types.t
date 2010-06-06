use strict;
use warnings;

use Test::More tests => 1;    # last test to print

use WWW::Ohloh::API::Types qw/ Ohloh_Id /;
use Moose::Util::TypeConstraints qw/ find_type_constraint /;

my $Ohloh_Id = find_type_constraint('WWW::Ohloh::API::Types::Ohloh_Id');

ok $Ohloh_Id->validate('foo'), 'bad id';

is $Ohloh_Id->coerce( '1234' ) => '1234', 'numerical id';
is $Ohloh_Id->coerce( 'yanick@somewhere.ca' ) => '', 'email id'; 

