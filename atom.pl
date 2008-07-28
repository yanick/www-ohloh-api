use strict;
use warnings;

open my $change_fh, '<', 'Changes' or die;

my @versions = ( [] );

LINE:
while (<$change_fh>) {
    if (/^v(\S+) - (.*)/) {
        my $version = $1;
        my $date    = $2;
        push @versions, [ $version, $date ];
        next LINE;
    }

    $versions[-1][2] .= $_;
}

shift @versions;

use XML::Atom::SimpleFeed;

my $feed = XML::Atom::SimpleFeed->new(
    title => 'WWW::Ohloh::API',
    id    => 'foo',
);
for my $v (@versions) {
    my ( $version, $date, $text ) = @$v;
    $feed->add_entry(
        title   => "version $version is out",
        updated => $date,
        content => { type => 'text', content => $text, },
        id      => 'foo',
        author  => 'Yanick Champoux',
    );
}

print $feed->print;
