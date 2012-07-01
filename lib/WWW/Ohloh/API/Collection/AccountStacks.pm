package WWW::Ohloh::API::Collection::AccountStacks;

use strict;
use warnings;

use Moose;

#extends 'WWW::Ohloh::API::Collection::Stacks';
with 'WWW::Ohloh::API::Collection';

has '+entry_class' => (
    default => 'WWW::Ohloh::API::Object::Stack',
);

around _build_request_url => sub {
    my( $inner, $self ) = @_;
    
    my $uri = $inner->($self);

    $self->has_id or $self->has_email 
        or die "id or email not provided for account, cannot fetch";

    my $id = $self->has_id ? $self->id : $self->email_md5; 

    $uri->path( 'accounts/' . $id . '/stacks.xml' );

    return $uri;
};

has id => (
    is      => 'ro',
    isa     => 'Int',
    lazy     => 1,
    predicate => 'has_id',
    default => sub {
    },
);

has email => (
    is      => 'rw',
    isa     => 'Str',
    lazy     => 1,
    default  => '',
    predicate => 'has_email',
);

has email_md5 => (
    is      => 'rw',
    isa     => 'Str',
    lazy     => 1,
    default => sub {
        md5_hex($_[0]->email);
    },
    predicate => 'has_email_md5',
);

1;
