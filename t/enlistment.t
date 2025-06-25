use strict;
use warnings;

use Test::More tests => 4;

use lib 't'; use FakeOhloh;

my $ohloh = Fake::Ohloh->new;

$ohloh->stash( 'foo', 'enlistments.xml' );

my $enlistments = $ohloh->fetch_enlistments( project_id => 1 );

my $e = $enlistments->next;

my %result = (
    id            => 20381,
    project_id    => 10716,
    repository_id => 19724,
);

for my $m ( keys %result ) {
    is $e->$m => $result{$m}, "$m()";
}

like $e->as_xml => qr#<(enlistment)>.*?</\1>#, 'as_xml()';

