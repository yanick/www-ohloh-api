package WWW::Ohloh::API::Kudo;

use strict;
use warnings;

use Carp;
use Object::InsideOut;
use XML::LibXML;
use WWW::Ohloh::API::KudoScore;

our $VERSION = '0.0.5';

my @api_fields = qw/ 
    created_at 
    sender_account_id
    sender_account_name
    receiver_account_name
    receiver_account_id
    project_id
    project_name
    contributor_id
    contributor_name
/;

my @created_at_of  :Field  :Set(_set_created_at) :Get(created_at);
my @sender_account_id_of  :Field  :Set(_set_sender_account_id) :Get(sender_account_id);
my @sender_account_name_of  :Field  :Set(_set_sender_account_name) :Get(sender_account_name);
my @receiver_account_name_of  :Field  :Set(_set_receiver_account_name) :Get(receiver_account_name);
my @receiver_account_id_of  :Field  :Set(_set_receiver_account_id) :Get(receiver_account_id);
my @project_id_of  :Field  :Set(_set_project_id) :Get(project_id);
my @project_name_of  :Field  :Set(_set_project_name) :Get(project_name);
my @contributor_id_of  :Field  :Set(_set_contributor_id) :Get(contributor_id);
my @contributor_name_of  :Field  :Set(_set_contributor_name) :Get(contributor_name);

my @request_url_of  :Field  :Arg(request_url)  :Get( request_url );
my @xml_of    :Field :Arg(xml);   
my @ohloh_of  :Field :Arg(ohloh) :Get(_ohloh);

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub _init :Init {
    my $self = shift;

    my $dom = $xml_of[ $$self ] or return;

    $self->_set_created_at( $dom->findvalue( "created_at/text()" ) );
    $self->_set_sender_account_id( $dom->findvalue( "sender_account_id/text()" ) );
    $self->_set_sender_account_name( $dom->findvalue( "sender_account_name/text()" ) );
    $self->_set_receiver_account_name( $dom->findvalue( "receiver_account_name/text()" ) );
    $self->_set_receiver_account_id( $dom->findvalue( "receiver_account_id/text()" ) );
    $self->_set_project_id( $dom->findvalue( "project_id/text()" ) );
    $self->_set_project_name( $dom->findvalue( "project_name/text()" ) );
    $self->_set_contributor_id( $dom->findvalue( "contributor_id/text()" ) );
    $self->_set_contributor_name( $dom->findvalue( "contributor_name/text()" ) );
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub recipient_type {
    my $self = shift;

    return $self->receiver_account_id ? 'account' : 'contributor';
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub sender {
    my $self = shift;

    return $self->_ohloh->get_account( id => $self->sender_account_id );
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub receiver {
    my $self = shift;

    if ( my $id = $self->receiver_account_id ) {
        return $self->_ohloh->get_account( id => $id );
    }

    return;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub as_xml { 
    my $self = shift; 
    my $xml;
    my $w = XML::Writer->new( OUTPUT => \$xml );

    $w->startTag( 'kudo' );
    for my $e ( @api_fields ) {
        $w->dataElement( $e => $self->$e ) if $self->$e;
    }

    $w->endTag;

    return $xml; 
}

'end of WWW::Ohloh::API::Kudo';
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

=head1 OVERLOADING

When the object is called in a string context, it'll be replaced by
the name associated with the account. E.g.,

    print $account;  # equivalent to 'print $account->name'

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

This document describes WWW::Ohloh::API version 0.0.5

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

