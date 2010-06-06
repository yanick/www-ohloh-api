package WWW::Ohloh::API::Fake;

use Moose;

extends 'WWW::Ohloh::API';

use Carp;

use XML::LibXML;
use WWW::Ohloh::API;

use MooseX::AttributeHelpers;

has stash => (
    metaclass => 'Collection::Array',
    isa => 'ArrayRef[Any]',
    default => sub { [] },
    provides => {
        push => 'push_stash',
        shift => 'shift_stash',
    },
);

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub stash {
    my $self = shift;
    my ( $url, $xml ) = @_;

    my $parser = XML::LibXML->new;

    my $dom =
      -f 't/samples/' . $xml
      ? $parser->parse_file( 't/samples/' . $xml )
      : $parser->parse_string($xml);

    $self->push_stash( [ $url, $dom->findnodes('//result[1]') ] );

    return $self;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

override '_query_server' => sub {
    my $self = shift;
    $DB::single = 1;
    return @{ $self->shift_stash || croak "no more results stashed" };
};


'end of FakeOhloh';
