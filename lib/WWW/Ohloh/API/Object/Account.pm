package WWW::Ohloh::API::Object::Account;

use Moose;

use MooseX::SemiAffordanceAccessor;
use WWW::Ohloh::API::Role::Attr::XMLExtract;

with qw/ 
    WWW::Ohloh::API::Role::Fetchable
/;

use WWW::Ohloh::API::Types qw/ OhlohId OhlohDate OhlohURI /;

use Carp;
use XML::LibXML;
use Time::Piece;
use Date::Parse;

use Digest::MD5 qw/ md5_hex /;

our $VERSION = '1.0_1';

use overload '""' => sub { $_[0]->name  };

=method id

Returns the account's id.

=method name()

Returns the public name of the account.

=cut

has id => (
    traits => [ 'WWW::Ohloh::API::Role::Attr::XMLExtract' ],
    is      => 'rw',
    isa     => 'Str',
    lazy     => 1,
    predicate => 'has_id',
);

has name => (
    traits => [ 'WWW::Ohloh::API::Role::Attr::XMLExtract' ],
    is      => 'rw',
    isa     => 'Str',
    lazy     => 1,
    predicate => 'has_name',
);


=method created_at()

Returns the time at which the account was created as a L<DateTime> object .

=method updated_at()

Returns the last time at which the account was modified as a L<DateTime>
object.

=cut

has [qw/ created_at updated_at /] => (
    traits => [ 'WWW::Ohloh::API::Role::Attr::XMLExtract' ],
    isa => OhlohDate,
    is => 'rw',
    coerce => 1,
);

=method homepage_url()

Returns the URL to a member's home page, such as a blog, as an L<Uri> object.

=method avatar_url()

Returns the URL to the profile image displayed on Ohloh pages, as an L<Uri>
object.


=cut

has [ qw/homepage_url avatar_url/ ] => (
    traits => [ 'WWW::Ohloh::API::Role::Attr::XMLExtract' ],
    is => 'rw',
    isa => OhlohURI,
    coerce => 1,
);

=method posts_count()

Returns the number of posts made to the Ohloh forums by this account.

=cut

has posts_count => (
    traits => [ 'WWW::Ohloh::API::Role::Attr::XMLExtract' ],
    is => 'rw',
    isa => 'Int',
);

=method location()

Returns a text description of this account holder's claimed location.

=method country_code()

Returns a string representing the account holder's country.

=cut

has [qw/ location country_code /] => (
    traits => [ 'WWW::Ohloh::API::Role::Attr::XMLExtract' ],
    is => 'rw',
    isa => 'Str',
);

=method latitude(), longitude()

Returns floating-point values representing the account's latitude and longitude, 
suitable for use with the Google Maps API.

=cut

has [ qw/ latitude longitude / ] => (
    traits => [ 'WWW::Ohloh::API::Role::Attr::XMLExtract' ],
    is => 'rw',
    isa => 'Num',
);


=method kudo_score()

Returns the L<WWW::Ohloh::API::Object::KudoScore> object associated with the
account.

=cut

has 'kudo_score' => (
    is => 'rw',
    isa => 'WWW::Ohloh::API::Object::KudoScore',
    lazy => 1,
    default => sub {
        my $self = shift;

        return WWW::Ohloh::API::Object::KudoScore->new(
            agent => $self->agent,
            xml_src => $self->xml_src->findnodes( 'kudo_score' )->[0],
        );
    },
);

has stack => (
    is => 'rw',
    isa => 'WWW::Ohloh::API::Object::Stack',
    lazy => 1,
    default => sub {
        my $self = shift;

        return WWW::Ohloh::API::Object::Stack->new(
            agent   => $self->agent,
            id      => $self->id,
            account => $self,
        );
    },
);


around _build_request_url => sub {
    my( $inner, $self ) = @_;
    
    my $uri = $inner->($self);

    $self->has_id or $self->has_email 
        or die "id or email not provided for account, cannot fetch";

    my $id = $self->has_id ? $self->id : $self->email_md5; 

    $uri->path( 'accounts/' . $id . '.xml' );

    return $uri;
};

has email => (
    is      => 'rw',
    isa     => 'Str',
    lazy     => 1,
    default  => '',
    predicate => 'has_email',
);

has email_md5 => (
    is      => 'rw',
    isa     => 'Str',
    lazy     => 1,
    default => sub {
        md5_hex($_[0]->email);
    },
    predicate => 'has_email_md5',
);

=method fetch( $id_type => $value )

Retrieves the account from Ohloh. The I<$id_type> can be 
C<id>, C<email> or C<email_md5>.

=cut

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1;

__END__
#<<<
my @kudo_of             : Field 
                        : Set(_set_kudo) 
                        : Get(kudo_score)
                        ;
#>>>
my @kudos_of : Field : Arg(kudos);

my @stack : Field;


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub load_xml {
    my ( $self, $dom ) = @_;

    $self->_set_id( $dom->findvalue('id/text()') );
    $self->_set_name( $dom->findvalue('name/text()') );
    $self->_set_created_at(
        scalar Time::Piece::gmtime(
            str2time( $dom->findvalue('created_at/text()') ) ) );
    $self->_set_updated_at(
        scalar Time::Piece::gmtime(
            str2time( $dom->findvalue('updated_at/text()') ) ) );
    $self->_set_homepage_url( $dom->findvalue('homepage_url/text()') );
    $self->_set_avatar_url( $dom->findvalue('avatar_url/text()') );
    $self->_set_posts_count( $dom->findvalue('posts_count/text()') );
    $self->_set_location( $dom->findvalue('location/text()') );
    $self->_set_country_code( $dom->findvalue('country_code/text()') );
    $self->_set_latitude( $dom->findvalue('latitude/text()') );
    $self->_set_longitude( $dom->findvalue('longitude/text()') );

    if ( my ($node) = $dom->findnodes('kudo_score[1]') ) {
        $kudo_of[$$self] = WWW::Ohloh::API::KudoScore->new( xml => $node );
    }
}

sub kudoScore {
    my $self = shift;
    return $kudo_of[$$self];
}

# aliases
*kudo = *kudoScore;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub stack {
    my $self = shift;

    my $retrieve = shift;
    $retrieve = 1 unless defined $retrieve;

    if ( $retrieve and not $stack[$$self] ) {
        $stack[$$self] = $self->ohloh->fetch_account_stack( $self->id );
        $stack[$$self]->set_account($self);
    }

    return $stack[$$self];
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub sent_kudos {
    my $self = shift;

    $kudos_of[$$self] ||= $self->ohloh->get_kudos( id => $self->id );

    return $kudos_of[$$self]->sent;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub received_kudos {
    my $self = shift;

    $kudos_of[$$self] ||= $self->ohloh->get_kudos( id => $self->id );

    return $kudos_of[$$self]->received;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub kudos {
    my $self = shift;

    return $kudos_of[$$self] ||= $self->ohloh->fetch_kudos( $self->id );
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

'end of WWW::Ohloh::API::Account';
__END__

=head1 NAME

WWW::Ohloh::API::Account - an Ohloh account

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );
    my $account $ohloh->fetch_account( 12933 );

    print $account->name;

=head1 DESCRIPTION

W::O::A::Account contains the information associated with an Ohloh 
account as defined at http://www.ohloh.net/api/reference/account. 
To be properly populated, it must be created via
the C<get_account> method of a L<WWW::Ohloh::API> object.

=head1 METHODS 

=head2 API Data Accessors






=head3 kudoScore, kudo_score, kudo

Return a L<WWW::Ohloh::API::KudoScore> object holding the account's 
kudo information, or I<undef> if the account doesn't have a kudo score
yet. All three methods are equivalent.

=head3 stack( $retrieve )

Return the stack associated with the account as a
L<WWW::Ohloh::API::Stack> object.

If the optional I<$retrieve> argument is given and false,
the stack will not be queried from the Ohloh server and,
if the information has not been retrieved previously, the method
will return nothing.

=head2 Other Methods

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

This document describes WWW::Ohloh::API version 1.0_1

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

