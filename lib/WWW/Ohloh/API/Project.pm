package WWW::Ohloh::API::Project;

use strict;
use warnings;

use Carp;
use Object::InsideOut;
use XML::Simple;
use WWW::Ohloh::API::Analysis;

our $VERSION = '0.0.1';

my @request_url_of  :Field  :Arg(request_url)  :Get( request_url );
my @xml_of  :Field :Arg(xml);   

my @id_of :Field :Get(id) :Set(_set_id) ;
my @name_of :Field :Get(name) :Set(_set_name) ;
my @created_at_of :Field :Get(created_at) :Set(_set_created_at) ;
my @updated_at_of :Field :Get(updated_at) :Set(_set_updated_at) ;
my @description_of :Field :Get(description) :Set(_set_description);
my @homepage_url_of :Field :Get(homepage_url) :Set(_set_homepage_url);
my @download_url_of :Field :Get(download_url) :Set(_set_download_url);
my @irc_url_of :Field :Get(irc_url) :Set(_set_irc_url);
my @stack_count_of :Field :Get(stack_count) :Set(_set_stack_count);
my @average_rating_of :Field :Get(average_rating) :Set(_set_average_rating);
my @rating_count_of :Field :Get(rating_count) :Set(_set_rating_count);
my @analysis_id_of :Field :Get(analysis_id) :Set(_set_analysis_id);
my @analysis_of :Field :Get(analysis);

sub _init :Init {
    my $self = shift;

    my $dom = $xml_of[ $$self ] or return;

    $self->_set_id( $dom->findvalue( 'id/text()' ) ); 
    $self->_set_name( $dom->findvalue( 'name/text()' ) ); 
    $self->_set_created_at( $dom->findvalue( 'created_at/text()' ) ); 
    $self->_set_updated_at( $dom->findvalue( 'updated_at/text()' ) ); 
    $self->_set_description( $dom->findvalue( 'description/text()' ) );
    $self->_set_homepage_url( $dom->findvalue( 'homepage_url/text()' ) );
    $self->_set_download_url( $dom->findvalue( 'download_url/text()' ) );
    $self->_set_irc_url( $dom->findvalue( 'irc_url/text()' ) );
    $self->_set_stack_count( $dom->findvalue( 'stack_count/text()' ) );
    $self->_set_average_rating( $dom->findvalue( 'average_rating/text()' ) );
    $self->_set_rating_count( $dom->findvalue( 'rating_count/text()' ) );
    $self->_set_analysis_id( $dom->findvalue( 'analysis_id/text()' ) );

    if ( my( $n ) = $dom->findnodes( 'analysis[1]' ) ) {
        $analysis_of[ $$self ] = WWW::Ohloh::API::Analysis->new( xml => $n );
    }

    return;
}

sub as_xml { my $self = shift; return XMLout( $xml_of[ $$self ], 
            RootName => 'project', NoAttr => 1 ); }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

'end of WWW::Ohloh::API::Project';
__END__

=head1 NAME

WWW::Ohloh::API::Account - an Ohloh account

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );
    my $account $ohloh->get_account( id => 12933 );

    print $account->name;

=head1 DESCRIPTION

W::O::A::Account contains the information associated with an Ohloh 
account as defined at http://www.ohloh.net/api/reference/account. 
To be properly populated, it must be created via
the C<get_account> method of a L<WWW::Ohloh::API> object.

=head1 METHODS 

=head2 API Data Accessors

=head3 id

Return the account's id.

=head3 name

Return the public name of the account.

=head3 created_at

Return the time at which the account was created.

=head3 updated_at

Return the last time at which the account was modified.

=head3 homepage_url

Return the URL to a member's home page, such as a blog, or I<undef> if not
configured.

=head3 avatar_url

Return the URL to the profile image displayed on Ohloh pages, or I<undef> if
not configured.

=head3 posts_count

Return the number of posts made to the Ohloh forums by this account.

=head3 location

Return a text description of this account holder's claimed location, or
I<undef> if not
available. 

=head3 country_code

Return a string representing the account holder's country, or I<undef> is
unavailable. 

=head3 latitude, longitude

Return floating-point values representing the account's latitude and longitude, 
suitable for use with the Google Maps API, or I<undef> is they are not
available.

=head3 kudoScore, kudo_score, kudo

Return a L<WWW::Ohloh::API::KudoScore> object holding the account's 
kudo information, or I<undef> if the account doesn't have a kudo score
yet. All three methods are equivalent.

=head2 Other Methods

=head3 as_xml

Return the account information (including the kudo score if it applies)
as an XML string.  Note that this is not the exact xml document as returned
by the Ohloh server: due to the current XML parsing module used
by W::O::A (to wit: L<XML::Simple>), the ordering of the nodes can differ.

=head1 SEE ALSO

=over

=item * 

L<WWW::Ohloh::API>, L<WWW::Ohloh::API::KudoScore>.

=item *

Ohloh API reference: http://www.ohloh.net/api/getting_started

=item * 

Ohloh Account API reference: http://www.ohloh.net/api/reference/account

=back

=head1 VERSION

This document describes WWW::Ohloh::API version 0.0.1

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



