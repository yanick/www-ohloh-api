package WWW::Ohloh::API::Role::Fetchable;

use strict;
use warnings;

use Object::InsideOut;

use Carp;
use Params::Validate qw/ validate_with validate /;

our $VERSION = '0.2.0';

my @request_url_of : Field : Arg(request_url) : Get( request_url );
my @ohloh_of : Field : Arg(ohloh) : Set( set_ohloh ) : Get(ohloh);

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub fetch {
    my ( $class, @args ) = @_;

    if ( ref $class ) {
        push @args, ohloh => $class->ohloh;
        $class = ref $class;
    }

    my %param = validate_with(
        params      => \@args,
        spec        => { ohloh => 1 },
        allow_extra => 1,
    );

    my $ohloh = $param{ohloh};
    delete $param{ohloh};

    my ($url) = $class->generate_query_url(%param);

    my ( undef, $xml ) = $ohloh->_query_server($url);

    my ($node) = $xml->findnodes( $class->element_name );

    return $class->new( ohloh => $ohloh, xml => $node, request_url => $url );
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub generate_query_url : Chained(bottom up) {
    my ( $self, $url, @args ) = @_;

    croak "$args[0] not a valid argument" if @args;

    return ($url);
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

'end of WWW::Ohloh::API::Role::Fetchable';
