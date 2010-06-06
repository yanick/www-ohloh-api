package WWW::Ohloh::API::Role::Fetchable;

use Moose::Role;
use Moose::Util::TypeConstraints;

use Carp;
use Params::Validate qw/ validate_with validate /;
use URI;
use URI::QueryParam;

our $VERSION = '1.0_1';

subtype 'My::Types::URI' => as class_type( 'URI' );

coerce 'My::Types::URI' =>
    from 'Str' => via { URI->new( $_ ) };

has request_url => (
    coerce => 1,
    isa => 'My::Types::URI',
    is => 'ro',
    writer => '_set_request_url',
    lazy => 1,
    default => sub {
        $_[0]->generate_query_url;
        $_[0]->request_url;
    },
);

has xml_src => (
    is => 'ro',
    writer => '_set_xml_src',
    predicate => 'has_xml_src',
    lazy => 1,
    default => sub {
        $_[0]->fetch;
        $_[0]->xml_src;
    },
);

has ohloh => (
    is => 'ro',
);

requires qw/ rest_url element_name  /;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub fetch {
    my ( $self, @args ) = @_;

    $DB::single = 1;

    my ( undef, $xml ) = $self->ohloh->_query_server($self->request_url);

    my ($node) = $xml->findnodes( '//result/child::*' );

    $self->_set_xml_src( $node );
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

before generate_query_url => sub {
    my ( $self ) = @_;

    my $uri = URI->new( $WWW::Ohloh::API::OHLOH_URL );

    my $params = $uri->query_form_hash;

    $params->{api_key} ||= $self->ohloh->api_key;
    $params->{v}       ||= $self->ohloh->api_version;

    $uri->query_form_hash( $params );

    $self->_set_request_url( $uri );
};

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

'end of WWW::Ohloh::API::Role::Fetchable';
