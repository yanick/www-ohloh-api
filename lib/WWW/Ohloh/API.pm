package WWW::Ohloh::API;

use warnings;
use strict;
use Carp;

use Object::InsideOut;

use LWP::Simple;
use LWP::UserAgent;
use Readonly;
use XML::Simple;
use WWW::Ohloh::API::Account;
use Digest::MD5 qw/ md5_hex /;

our $VERSION = '0.0.1';

Readonly our $OHLOH_URL => 'http://www.ohloh.net/';

our $useragent_signature = "WWW-Ohloh-API/$VERSION";

my @api_key_of :Field :Std(api_key) :Arg(api_key);
my @api_version_of :Field :Default(1);   # for now, there's only v1

my @user_agent_of :Field;

my @debugging :Field :Arg(debug) :Default(0) :Std(debug);

sub get_account {
    my $self = shift;

    my( $type, $id ) = @_;

    $type eq 'id' or $type eq 'email' 
        or croak "first argument must be 'id' or 'email'";

    $id = md5_hex( $id ) if $type eq 'email';

    my( $url, $xml ) = $self->_query_server( "accounts/$id.xml" );

    return WWW::Ohloh::API::Account->new( 
        request_url => $url,
        xml => $xml->{account},
    );
}

sub _ua {
    my $self = shift;
    my $ua;
    unless ( $ua = $user_agent_of[ $$self ] ) {
        $ua = $user_agent_of[ $$self ] = LWP::UserAgent->new;
        $ua->agent( $useragent_signature );
    }
    return $ua;
}

sub _query_server {
    my $self = shift;
    my $url = shift;
    my %param = $_[0] ? %{$_[0]} : ();

    $param{api_key} = $self->get_api_key
        or croak "api key not configured";

    $param{v} = $api_version_of[ $$self ];
    
    $url = $OHLOH_URL . $url;

    $url .= '?' . join '&', map { "$_=$param{$_}" } keys %param;

    warn "querying ohloh server with $url" if $debugging[ $$self ];

    # TODO: beef up here for failures
    my $request = HTTP::Request->new(GET => $url );
    my $response = $self->_ua->request( $request );

    unless ( $response->is_success ) {
        croak "http query to Ohloh server failed: " . 
                    $response->status_line;
    }

    my $result = $response->content;

    my $xml = XMLin( $result, SuppressEmpty => undef );

    if ( $xml->{status} ne 'success' ) {
        croak "query to Ohloh server failed: ", $xml->{status};
    }

    return $url, $xml->{result};
}

1; # Magic true value required at end of module
__END__

=head1 NAME

WWW::Ohloh::API - Ohloh API implementation

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );
    my $account $ohloh->get_account( id => 12933 );

    print $account->name;

=head1 DESCRIPTION

This module is a Perl interface to the Ohloh API as defined at
http://www.ohloh.net/api/getting_started. 

=head1 METHODS 

=head2 new( [ api_key => $api_key ] )

Create a new WWW::Ohloh::API object. To be able to retrieve information
from the Ohloh server, an api key must be either passed to the constructor 
or set via the L<set_api_key> method.

    my $ohloh = WWW::Ohloh::API->new( api_key => $your_key );

=head2 get_account( id => $account_id )

Return the account associated with the id, as a L<WWW::Ohloh::API::Account>
object. If no such account exists, an error is thrown.

    my $account = $ohloh->get_account( id => 12933 );

=head1 SEE ALSO

=over

=item *

L<WWW::Ohloh::API::Account>, 
L<WWW::Ohloh::API::KudoScore>.

=item *

Ohloh API reference: http://www.ohloh.net/api/getting_started

=item * 

How to obtain an Ohloh API key: http://www.ohloh.net/api_keys/new

=back

=head1 VERSION

This document describes WWW::Ohloh::API version 0.0.1

=head1 BUGS AND LIMITATIONS

WWW::Ohloh::API is very extremely alpha quality. It'll improve,
but till then: I<Caveat emptor>.

Please report any bugs or feature requests to
C<bug-www-ohloh-api@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Yanick Champoux  C<< <yanick@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Yanick Champoux C<< <yanick@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

