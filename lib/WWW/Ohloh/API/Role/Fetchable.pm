package WWW::Ohloh::API::Role::Fetchable;

use Moose::Role;
use Moose::Util::TypeConstraints;

use Carp;
use Params::Validate qw/ validate_with validate /;
use URI;
use URI::URL;
use URI::QueryParam;

has request_url => (
    is => 'rw',
    writer => '_set_request_url',
    lazy => 1,
    builder => '_build_request_url',
    clearer => 'clear_request_url',
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

has agent => (
    isa => 'WWW::Ohloh::API',
    is => 'ro',
);

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub fetch {
    my ( $self, @args ) = @_;

    my $xml = $self->agent->_query_server($self->request_url);

    $self->_set_xml_src( $xml->findnodes( '//result/child::*' ));

    return $self;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub _build_request_url {
    my ( $self ) = @_;

    my $uri = URI::URL->new( $WWW::Ohloh::API::OHLOH_URL );

    my $params = $uri->query_form_hash;

    $params->{api_key} ||= $self->agent->api_key;
    $params->{v}       ||= $self->agent->api_version;

    $uri->query_form_hash( $params );

    return $uri;
};

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

'end of WWW::Ohloh::API::Role::Fetchable';
