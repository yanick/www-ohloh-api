package WWW::Ohloh::API::Languages;

use strict;
use warnings;

use Carp;
use Object::InsideOut qw/ WWW::Ohloh::API::Collection/ ;
use XML::LibXML;
use Readonly;
use List::MoreUtils qw/ any /;
use WWW::Ohloh::API::Language;

our $VERSION = '0.1.0';


my @ALLOWED_SORTING;
Readonly @ALLOWED_SORTING =>
  qw/ total code projects comment_ratio contributors commits name /;

sub element { return 'WWW::Ohloh::API::Language' }
sub element_name { return 'language' }
sub query_path { return 'languages.xml' }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub is_allowed_sort {
    my $s = shift;
    return any { $s eq $_ } @ALLOWED_SORTING;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub _init : Init {
    my $self = shift;

    return;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

'end of WWW::Ohloh::API::Languages';
__END__

=head1 NAME

WWW::Ohloh::API::Languages - a set of Ohloh languages

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );
    my $languages = $ohloh->get_languages( sort => 'code' );

    for my $l ( $languages->all ) {
        print $l->nice_name;
    }

=head1 DESCRIPTION

W::O::A::Languages returns the list of languages known to Ohloh.
To be properly populated, it must be created via
the C<get_languages> method of a L<WWW::Ohloh::API> object.

=head1 METHODS 

=head2 all

Returns the retrieved languages' information as
L<WWW::Ohloh::API::Language> objects.

=head2 next

Returns the next language, or I<undef> if there is no more languages
to retrieve.  On a subsequent call to <next>, the list is reset and
the first language is returned once more.



=head1 SEE ALSO

=over

=item * 

L<WWW::Ohloh::API>, 
L<WWW::Ohloh::API::Language>, 
L<WWW::Ohloh::API::Project>,
L<WWW::Ohloh::API::Analysis>, 
L<WWW::Ohloh::API::Account>.


=item *

Ohloh API reference: http://www.ohloh.net/api/getting_started

=item * 

Ohloh Account API reference: http://www.ohloh.net/api/reference/language

=back

=head1 VERSION

This document describes WWW::Ohloh::API version 0.1.0

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

=cut
