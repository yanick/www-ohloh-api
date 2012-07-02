package WWW::Ohloh::API::Object::Account;
#ABSTRACT: an Ohloh account

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );

    my $account = $ohloh->fetch( 'Account', id => 12933 );

    print $account->name;

=cut

use Moose;

use MooseX::SemiAffordanceAccessor;
use WWW::Ohloh::API::Role::Attr::XMLExtract;

with qw/ 
    WWW::Ohloh::API::Role::Fetchable
/;

use WWW::Ohloh::API::Types qw/ OhlohId OhlohDate OhlohURI /;

use Digest::MD5 qw/ md5_hex /;

use overload '""' => sub { $_[0]->name  };

around _build_request_url => sub {
    my( $inner, $self ) = @_;
    
    my $uri = $inner->($self);

    $self->has_id or $self->has_email or $self->has_email_md5
        or die "id or email not provided for account, cannot fetch";

    my $id = $self->has_id ? $self->id : $self->email_md5; 

    $uri->path( 'accounts/' . $id . '.xml' );

    return $uri;
};

=method new( @args )

Creates a new C<WWW::Ohloh::API::Object::Account> object. To be fetchable, one
of the three parameters I<id>, I<email> or I<email_md5> has to be passed.

=head2 Arguments

=over

=item id

=item email

=item email_md5

The md5 hash of the email associated with the account.

=back


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

=method stack

Returns the L<WWW::Ohloh::API::Object::Stack> object associated with the
account.

=cut

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



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1;

__END__

=head1 DESCRIPTION

C<WWW::Ohloh::API::Object::Account>
contains the information associated with an Ohloh 
account as defined at L<http://www.ohloh.net/api/reference/account>. 

=head1 OVERLOADING

When the object is called in a string context, it'll be replaced by
the name associated with the account. E.g.,

    print $account;  # equivalent to 'print $account->name'

=head1 SEE ALSO

=over

=item *

Ohloh API reference: http://www.ohloh.net/api/getting_started

=item * 

Ohloh Account API reference: http://www.ohloh.net/api/reference/account

=back

