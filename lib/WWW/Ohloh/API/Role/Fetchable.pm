package WWW::Ohloh::API::Role::Fetchable;
our $AUTHORITY = 'cpan:YANICK';

use strict;
use warnings;

use Object::InsideOut;

use Carp;
use Params::Validate qw/ validate_with validate /;
use URI;

our $VERSION = '1.0_1';

#<<<
my @request_url_of  : Field 
                    : Arg(Name => 'request_url', Preproc => \&WWW::Ohloh::API::Role::Fetchable::process_url) 
                    : Get(request_url) 
                    : Type(URI);
my @ohloh_of        : Field 
                    : Arg(ohloh) 
                    : Set(set_ohloh) 
                    : Get(ohloh);
#>>>
sub process_url {
    my $value = $_[4];

    return URI->new($value);
}

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

    my ($url) = $class->generate_query_url(%param);

    my ( undef, $xml ) = $ohloh->_query_server($url);

    my ($node) = $xml->findnodes( $class->element_name );

    return $class->new( ohloh => $ohloh, xml => $node, request_url => $url );
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub generate_query_url : Chained(bottom up) {
    my ( $self, $url, %args ) = @_;

    my $ohloh = $args{ohloh};
    delete $args{ohloh};
    $args{api_key} ||= $ohloh->get_api_key;
    $args{v}       ||= $ohloh->get_api_version;

    no warnings qw/ uninitialized /;

    return $WWW::Ohloh::API::OHLOH_URL . $url . '?' . join '&',
      map { $_ . '=' . $args{$_} } reverse sort keys %args;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

'end of WWW::Ohloh::API::Role::Fetchable';

__END__

=pod

=encoding UTF-8

=head1 NAME

WWW::Ohloh::API::Role::Fetchable

=head1 VERSION

version 1.0.2

=head1 AUTHOR

Yanick Champoux <yanick@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2025, 2008 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
