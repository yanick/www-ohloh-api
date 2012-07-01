package WWW::Ohloh::API::Test;

use strict;
use warnings;

use Moose;

use Path::Class;

extends 'WWW::Ohloh::API';

has stash => (
    is => 'ro',
    traits => [ 'Hash' ],
    isa => 'HashRef',
    default => sub { {} },
);

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub stash_file {
    my $self = shift;

    while( my ( $url, $file ) = splice @_, 0, 2 ) {
        $self->stash_string( $url => scalar file($file)->slurp );
    }
}

sub stash_string {
    my $self = shift;

    while( my ( $url, $xml ) = splice @_, 0, 2 ) {
        $self->stash->{$url} = $xml;
    }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

override '_fetch_object' => sub {
    my $self = shift;
    my $url = shift;
    return $self->stash->{$url} || die "url '$url' wasn't stashed\n";
};


1;



