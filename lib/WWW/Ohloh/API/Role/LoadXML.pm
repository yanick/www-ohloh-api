package WWW::Ohloh::API::Role::LoadXML;
our $AUTHORITY = 'cpan:YANICK';
$WWW::Ohloh::API::Role::LoadXML::VERSION = '1.0.2';
use strict;
use warnings;

use Object::InsideOut;

my %init_args : InitArgs = ( 'xml' => '', );

sub _init : Init {
    my ( $self, $args ) = @_;

    $self->load_xml( $args->{xml} ) if $args->{xml};
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WWW::Ohloh::API::Role::LoadXML

=head1 VERSION

version 1.0.2

=head1 AUTHOR

Yanick Champoux <yanick@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2025, 2008 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
