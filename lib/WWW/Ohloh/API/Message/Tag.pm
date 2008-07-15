package WWW::Ohloh::API::Message::Tag;

use strict;
use warnings;

use Carp;
use Object::InsideOut;
use XML::LibXML;

our $VERSION = '0.1.0';

my @request_url_of : Field : Arg(request_url) : Get( request_url );
my @xml_of : Field : Arg(xml);
my @ohloh_of : Field : Arg(ohloh);

my @type_of : Field : Set(set_type) : Get(id);
my @uri_of : Field : Set(set_uri) : Get(uri);
my @content_of : Field : Set(set_content) : Get(content);

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub load_xml {
    my $self = shift;
    my $dom  = shift;

    my $type = $dom->nodeName;
    die "tag is of type $type, should be 'project' or 'account'"
      unless any { $_ eq $type } qw/ project account /;

    $self->set_type($type);
    $self->set_uri( $dom->getAttribute('uri') );
    $self->set_content( $dom->findvalue('text()') );
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub as_xml {
    my $self = shift;
    my $xml;
    my $w = XML::Writer->new( OUTPUT => \$xml );

    $w->dataElement( $self->type, $self->content, uri => $self->uri );

    return $xml;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub is_project {
    return $_[0]->type eq 'project';
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub is_account {
    return $_[0]->type eq 'account';
}

'end of WWW::Ohloh::API::Message::Tag';

__END__

=head1 NAME

WWW::Ohloh::API::Language - a programming language information on Ohloh

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );
    my $languages =  $ohloh->get_languages;

    my ( $perl  ) = grep { $_->nice_name eq 'Perl' } $languages->all;

    print $perl->projects, " projects use Perl";

=head1 DESCRIPTION

W::O::A::Language contains the information associated with a programming
language recognized by Ohloh as defined at http://www.ohloh.net/api/reference/language. 
To be properly populated, it must be created via
the C<get_languages> or C<get_language> method of a L<WWW::Ohloh::API> object.

=head1 METHODS 

=head2 API Data Accessors

=head3 id

Return the language's unique id.

=head3 name

Return the short name of the language.

=head3 nice_name

Return the human-friendly name of the language.

=head3 category

Return the type of language, which can be either C<code> or
C<markup>.

=head3 is_markup

Return true if the language is a markup language, false if it's a
code language.

=head3 is_code 

Return true if the language is a code language, false if it's a
markup language.


=head3 code

Return the total number of lines of code, excluding comments and blank lines, written
in the language across all projects.

=head3 comments

Return the total number of comment lines,  written
in the language across all projects.

=head3 blanks

Return the total number of blanks lines,  written
in the language across all projects.

=head3 comment_ratio

Return the ratio of comment lines over the total number of lines for all projects using
the language.

=head3 projects

Return the number of projects using this language.

=head3 contributors

Return the number of contributors who have written at least one line of code
using this language.

=head3 commits

Return the number of commits which include at least one line in this language.

=head2 Other Methods

=head3 as_xml

Return the language information 
as an XML string.  Note that this is not the exact xml document as returned
by the Ohloh server. 

=head1 SEE ALSO

=over

=item * 

L<WWW::Ohloh::API>, 
L<WWW::Ohloh::API::KudoScore>.

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

The C<as_xml()> method returns a re-encoding of the account data, which
can differ of the original xml document sent by the Ohloh server.

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


