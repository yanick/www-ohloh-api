package WWW::Ohloh::API::Object::Stack;

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

has id => (
    traits =>  [ 'XMLExtract' ],
    is      => 'rw',
    isa     => 'Int',
);

has title => (
    is      => 'rw',
    isa     => 'Str',
    lazy     => 1,
    default => sub {
        $_[0]->xml_src->findvalue('title') || 'default';
    },
);

has account_id => (
    traits => [ 'XMLExtract' ],
    is      => 'rw',
    isa     => 'Int',
    lazy     => 1,
);

has description => (
    traits => [ 'XMLExtract' ],
    is      => 'rw',
    isa     => 'Str',
);

has updated_at => (
    traits => [ 'XMLExtract' ],
    is      => 'rw',
    isa     => OhlohDate,
    coerce => 1,
);

has project_count => (
    traits => [ 'XMLExtract' ],
    is      => 'rw',
    isa     => 'Int',
);

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

my @api_fields = qw/
  id
  updated_at
  project_account
  stack_entries
  account_id
  /;

has $_ => (
    traits => [ 'WWW::Ohloh::API::Role::Attr::XMLExtract' ],
    is => 'ro',
    predicate => 'has_'.$_,
) for @api_fields;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub element_name { return 'stack'; }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub _build_rest_url  {
    my ( $self, @args ) = @_;

    $self->id or croak "id must be specified to retrieve data";

    my $id = $self->id;

    if ( index( $id, '@' ) > -1 ) {
        $id = md5_hex($id);
    }

    $self->rest_url->path( "/accounts/$id/stacks/default.xml" );
}

'end of WWW::Ohloh::API::Stack';
__END__

=begin test

use lib 't';
use FakeOhloh;
use WWW::Ohloh::API::Stack;

my $ohloh = Fake::Ohloh->new;

$ohloh->stash( 'yadah', 'stack.xml' );

my $thingy = $ohloh->fetch_account_stack( 123 );

=end test

=head1 NAME

WWW::Ohloh::API::Stack - a collection of projects used by a person 

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );

    # get the stack of a person
    my $stack = $ohloh->fetch_account_stack( $account_id );

    # get stacks containing a project
    my @stacks = $ohloh->get_project_stacks( $project_id );


=head1 DESCRIPTION

W::O::A::Stack represents a collection of projects used
by a person. 

=head1 METHODS 

=for test ignore

=head2 API Data Accessors

=for test

=head3 id

Returns the unique id for the stack.

=for test
    is $result[0] => 21420, 'id()';

=head3 updated_at

Returns the most recent time at which any projects were added to
or removed from this stack as a L<Time::Piece> object.

=for test
    isa_ok $result[0], 'Time::Piece';
    is $result[0], 'Mon Mar 17 17:09:16 2008', 'updated_at()';

=head3 project_count

Returns the number of projects in the stack.

=head3 stack_entries

Returns a list of the entries contained by the stack as
L<WWW::Ohloh::API::StackEntry> objects.

=for test
    isa_ok $_, 'WWW::Ohloh::API::StackEntry' for @result;
    is @result => 35, '35 stack entries';

=head3 account_id

Returns the id of the account owning the stack.

=for test
    $ohloh->stash( 'account', 'account.xml' );
    my $retrieve = 1;

=head3 account( I<$retrieve> )

Returns the account associated 
to the stack as a L<WWW::Ohloh::API::Account> object.

If the account information was not present at the object's
creation time, it will be queried from the ohloh server,
unless I<$retrieve> is defined and set to false.

=for test
    isa_ok $result[0], 'WWW::Ohloh::API::Account';
    # querying it again shouldn't cause a fetch
    is $thingy->account => $result[0], 'querying again';

=for test ignore

=head2 Other Methods

=for test

=head3 as_xml

Returns the stack as an XML string.  
Note that this is not the same xml document as returned
by the Ohloh server. 

=for test
    use XML::LibXML;
    ok( XML::LibXML->new->parse_string( $result[0] ), 'as_xml' );

=head1 SEE ALSO

=over

=item * 

L<WWW::Ohloh::API>. 

=item *

Ohloh API reference: http://www.ohloh.net/api/getting_started

=item * 

Ohloh Account API reference: http://www.ohloh.net/api/reference/stack

=back

=head1 VERSION

This document describes WWW::Ohloh::API version 1.0_1

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
