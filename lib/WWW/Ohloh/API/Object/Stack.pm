package WWW::Ohloh::API::Object::Stack;
# ABSTRACT: a collection of projects used by an account 

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );

    # get the stack of an account
    my $stack = $ohloh->fetch( 'AccountStacks' => id => $account_id );

=cut

use Moose;

use MooseX::SemiAffordanceAccessor;
use WWW::Ohloh::API::Role::Attr::XMLExtract;

with qw/ 
    WWW::Ohloh::API::Role::Fetchable
/;

use WWW::Ohloh::API::Types qw/ OhlohDate /;
use WWW::Ohloh::API::Object::StackEntry;

use Carp;
use XML::LibXML;
use Readonly;
use Scalar::Util qw/ weaken /;
use Date::Parse;
use Time::Piece;
use Digest::MD5 qw/ md5_hex /;

has account => (
    is      => 'rw',
    isa     => 'WWW::Ohloh::API::Object::Account',
    lazy     => 1,
    default => sub {
        my $self = shift;

        return WWW::Ohloh::API::Object::Account->new(
            agent => $self->agent,
            xml_src => $self->xml_src->findnodes( 'account' ),
        );
    },
);

=method id

Returns the unique id for the stack.

=cut

has id => (
    traits =>  [ 'XMLExtract' ],
    is      => 'rw',
    isa     => 'Int',
);

=method title

Returns the name of the stack. The value returned for the default stack is
I<default>.

=cut

has title => (
    is      => 'rw',
    isa     => 'Str',
    lazy     => 1,
    default => sub {
        $_[0]->xml_src->findvalue('title') || 'default';
    },
);

=method account_id

Returns the id of the account to which the stack belongs.

=cut

has account_id => (
    traits => [ 'XMLExtract' ],
    is      => 'rw',
    isa     => 'Int',
    lazy     => 1,
);

=method description

Returns the description text of the stack.

=cut

has description => (
    traits => [ 'XMLExtract' ],
    is      => 'rw',
    isa     => 'Str',
);

=method updated_at

Returns the most recent time at which any projects were added to
or removed from this stack as a L<DateTime> object.

=cut

has updated_at => (
    traits => [ 'XMLExtract' ],
    is      => 'rw',
    isa     => OhlohDate,
    coerce => 1,
);

=method project_count

Returns the number of projects in the stack.

=cut

has project_count => (
    traits => [ 'XMLExtract' ],
    is      => 'rw',
    isa     => 'Int',
);


=method all_entries

Returns all entries contained by the stack as a list of 
L<WWW::Ohloh::API::Object::StackEntry> objects.

=method entry($index)

Returns the I<i>th entry of the stack, as a
L<WWW::Ohloh::API::Object::StackEntry> object.

=cut

has entries => (
    traits => ['Array'], 
    is => 'ro',
    isa => 'ArrayRef',
    lazy => 1,
    default => sub {
        my $self = shift;

        return [
            map {
                WWW::Ohloh::API::Object::StackEntry->new(
                    agent   => $self->agent,
                    xml_src => $_
                )
            }
            $self->xml_src->findnodes('//stack_entries/stack_entry' ) 
        ];
    },
    handles => {
        all_entries => 'elements',
        entry => 'get',
    },
);

1;

__END__

=head1 DESCRIPTION

C<WWW::Ohloh::API::Object::Stack> represents a collection of projects used
by an account.
