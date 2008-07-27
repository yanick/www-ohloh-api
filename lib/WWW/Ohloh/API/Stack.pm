package WWW::Ohloh::API::Stack;

use strict;
use warnings;

use Carp;
use Object::InsideOut;
use XML::LibXML;
use Readonly;
use Scalar::Util qw/ weaken /;

use WWW::Ohloh::API::StackEntry;

our $VERSION = '0.2.0';

my @ohloh_of : Field : Arg(ohloh);
my @request_url_of : Field : Arg(request_url) : Get( request_url );
my @xml_of : Field : Arg(xml);

my @api_fields = qw/
  id
  updated_at
  project_count
  stack_entries
  account_id
  account
  /;

__PACKAGE__->create_field( '%' . $_, ":Set(_set_$_)", ":Get($_)" )
  for qw/ id updated_at project_count account_id /;

my @stack_entries_of : Field;
my @account_of : Field;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub _init : Init {
    my $self = shift;

    my $dom = $xml_of[$$self] or return;

    for my $f (qw/ id updated_at project_count account_id /) {
        my $method = "_set_$f";
        $self->$method( $dom->findvalue("$f/text()") );
    }

    if ( my ($account_xml) = $dom->findnodes('account[1]') ) {
        $account_of[$$self] = WWW::Ohloh::API::Account->new(
            ohloh => $ohloh_of[$$self],
            xml   => $account_xml,
        );
    }

    $stack_entries_of[$$self] = [
        map WWW::Ohloh::API::StackEntry->new(
            ohloh => $ohloh_of[$$self],
            xml   => $_,
          ) => $dom->findnodes('stack_entries/stack_entry') ];

    return;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub stack_entries {
    my $self = shift;
    return @{ $stack_entries_of[$$self] };
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub as_xml {
    my $self = shift;
    my $xml;
    my $w = XML::Writer->new( OUTPUT => \$xml );

    $w->startTag('stack');

    for my $f (qw/ id updated_at project_count account_id /) {
        $w->dataElement( $f => $self->$f );
    }

    if ( my $account = $account_of[$$self] ) {
        $xml .= $account->as_xml;
    }

    if ( my @entries = @{ $stack_entries_of[$$self] } ) {
        $w->startTag('stack_entries');
        $xml .= $_->as_xml for @entries;
        $w->endTag;
    }

    $w->endTag;

    return $xml;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub account {
    my $self = shift;

    my $retrieve = shift;

    $retrieve = 1 unless defined $retrieve;

    if ($retrieve) {
        $account_of[$$self] ||=
          $ohloh_of[$$self]->get_account( id => $self->account_id );
    }

    return $account_of[$$self];

}

sub set_account : Private( WWW::Ohloh::API::Account ) {
    my $self = shift;

    weaken( $account_of[$$self] = shift );

    return;
}

'end of WWW::Ohloh::API::Stack';
__END__

=head1 NAME

WWW::Ohloh::API::Stack - a collection of projects used by a person 

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );

    # get the stack of a person
    my $stack = $ohloh->get_account_stack( $account_id );

    # get stacks containing a project
    my @stacks = $ohloh->get_project_stacks( $project_id );


=head1 DESCRIPTION

W::O::A::Stack represents a collection of projects used
by a person. 

=head1 METHODS 

=head2 API Data Accessors

=head2 id

Returns the unique id for the stack.

=head2 updated_at

Returns the most recent time at which any projects were added to
or removed from this stack.

=head2 project_count

Returns the number of projects in the stack.

=head2 stack_entries

Returns an array of the entries contained by the stack (see
L<WWW::Ohloh::API::StackEntry>).

=head2 account_id

Returns the id of the account owning the stack.

=head2 account

    $account = $stack->account( $retrieve );

Returns the account associated 
to the stack as a L<WWW::Ohloh::API::Account> object.

If the account information was not present at the object's
creation time, it will be queried from the ohloh server,
unless I<$retrieve> is defined and set to false.


=head2 Other Methods

=head3 as_xml

Return the stack as an XML string.  
Note that this is not the same xml document as returned
by the Ohloh server. 

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

This document describes WWW::Ohloh::API version 0.2.0

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
