package WWW::Ohloh::API;
# ABSTRACT: Ohloh API implementation

use Carp;

use Moose;

use MooseX::SemiAffordanceAccessor;

use Module::Pluggable 
    require => 1,
    search_path => [qw/ WWW::Ohloh::API::Object WWW::Ohloh::API::Collection /];

use LWP::UserAgent;
use Readonly;
use XML::LibXML;
use List::Util qw/ first /;

use Digest::MD5 qw/ md5_hex /;

with 'MooseX::Role::Loggable';

our $OHLOH_HOST = 'www.ohloh.net';
our $OHLOH_URL = "http://$OHLOH_HOST";

our $useragent_signature = join '/', 'WWW-Ohloh-API', ( eval q{$VERSION} || 'dev' );

has '+log_to_stdout' => (
    default => sub { $_[0]->debug },
);

has api_key => (
    is => 'rw',
);

has api_version => (
    is => 'rw',
    default => 1,
);

has user_agent => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $ua = LWP::UserAgent->new;
        $ua->agent($useragent_signature);
        return $ua;
    }
);

has xml_parser => (
    is => 'ro',
    lazy => 1,
    default => sub {
        return XML::LibXML->new;
    }
);


=method new( api_key => $api_key )

Creates a new C<WWW::Ohloh::API> object. To be able to retrieve information
from the Ohloh server, an api key must be either passed to the constructor 
or set via the L<set_api_key> method.

    my $ohloh = WWW::Ohloh::API->new( api_key => $your_key );

=method fetch( $object_type => @args, \%request_params )

Fetches the object or collection object determined by the C<@args>. 
For collections, an optional set of request parameters can be passed as well.

For more details, see the C<fetch()> method of the individual
C<WWW::Ohloh::API::Object::*> and C<WWW::Ohloh::API::Collection::*>
classes.

    my $account = $ohloh->fetch( Account => id => 12933 );

=cut

sub fetch {
    my ( $self, $object, @args ) = @_;

    my $class = first { /::$object$/ } $self->plugins 
        or croak "object or collection '$object' not found";
$DB::single = 1;
    return $class->new( agent => $self, @args, )->fetch;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub _query_server {
    my $self  = shift;
    my $url   = shift;

    unless ( ref $url eq 'URI' ) {
        $url = URI->new( $url );
    }

    $self->log( "fetching " . $url );

    my $result = $self->_fetch_object($url);

    $self->log( "result:\n" . $result );

    my $dom = eval { $self->xml_parser->parse_string($result) }
      or croak "server didn't feed back valid xml: $@";

    if ( $dom->findvalue('/response/status/text()') ne 'success' ) {
        croak "query to Ohloh server failed: ",
          $dom->findvalue('/response/status/text()');
    }

    return $url, $dom->findnodes('/response/result[1]');
}

sub _fetch_object {
    my ( $self, $url ) = @_;
    # TODO: beef up here for failures
    my $request = HTTP::Request->new( GET => $url );
    my $response = $self->user_agent->request($request);

    unless ( $response->is_success ) {
        croak "http query to Ohloh server failed: " . $response->status_line;
    }

    return $response->content;
}

1;

__END__

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );
    my $account = $ohloh->fetch( 'Account' => 12933 );

    print $account->name;

=head1 DESCRIPTION

This module is a Perl interface to the Ohloh API as defined at
http://www.ohloh.net/api/getting_started. 

=head1 SEE ALSO

=over

=item *

Ohloh API reference: http://www.ohloh.net/api/getting_started

=item * 

How to obtain an Ohloh API key: http://www.ohloh.net/api_keys/new

=back

