package    # mask from CPAN?
        Fake::Ohloh;

use strict;
use warnings;

use Object::InsideOut;
use base qw/ WWW::Ohloh::API /;

use XML::LibXML;
use WWW::Ohloh::API;

my @results_of :Field;
my @parser_of  :Field;


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub parser {
    my $self = shift;
    return $parser_of[ $$self ] ||= XML::LibXML->new;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub stash {
    my $self = shift;

    push @{ $results_of[ $$self ] }, [ 
        shift,
        $self->parser->parse_string( shift )->findnodes( '//result[1]' )
    ];

    return $self;
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub _query_server {
    my $self = shift;
    return @{ shift @{ $results_of[ $$self ] } };
}

'end of FakeOhloh';
