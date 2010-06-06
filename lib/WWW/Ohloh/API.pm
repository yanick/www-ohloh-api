package WWW::Ohloh::API;

use MooseX::SemiAffordanceAccessor;

use Carp;

use Moose;

use LWP::UserAgent;
use Readonly;
use XML::LibXML;
use Params::Validate qw(:all);


use Digest::MD5 qw/ md5_hex /;

our $VERSION = '1.0_1';

Readonly our $OHLOH_HOST => 'www.ohloh.net';

our $useragent_signature = "WWW-Ohloh-API/$VERSION";

has api_key => (
    is => 'rw',
);

has api_version => (
    is => 'rw',
    default => 1,
);

has user_agent => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $ua = LWP::UserAgent->new;
        $ua->agent($useragent_signature);
        return $ua;
    }
);

has xml_parser => (
    is => 'ro',
    lazy => 1,
    default => sub {
        return XML::LibXML->new;
    }
);


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub _query_server {
    my $self  = shift;
    my $url   = shift;

    unless ( ref $url eq 'URI' ) {
        $url = URI->new( $url );
    }

    $url->host( $OHLOH_HOST );
    $url->schema('http');
    $url->query_param( v => $self->api_version );
    $url->query_param( api_key -> $self->api_key );

    # TODO: beef up here for failures
    my $request = HTTP::Request->new( GET => $url );
    my $response = $self->user_agent->request($request);

    unless ( $response->is_success ) {
        croak "http query to Ohloh server failed: " . $response->status_line;
    }

    my $result = $response->content;

    my $dom = eval { $self->_parser->parse_string($result) }
      or croak "server didn't feed back valid xml: $@";

    if ( $dom->findvalue('/response/status/text()') ne 'success' ) {
        croak "query to Ohloh server failed: ",
          $dom->findvalue('/response/status/text()');
    }

    return $url, $dom->findnodes('/response/result[1]');
}

1;    # Magic true value required at end of module

__END__

=head1 NAME

WWW::Ohloh::API - Ohloh API implementation

=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );
    my $account = $ohloh->fetch_account( 12933 );

    print $account->name;

=head1 DESCRIPTION

This module is a Perl interface to the Ohloh API as defined at
http://www.ohloh.net/api/getting_started. 

=head1 METHODS 

=head2 new( [ api_key => $api_key ] )

Create a new WWW::Ohloh::API object. To be able to retrieve information
from the Ohloh server, an api key must be either passed to the constructor 
or set via the L<set_api_key> method.

    my $ohloh = WWW::Ohloh::API->new( api_key => $your_key );

=head2 fetch_account( $account_id )

Return the account associated with the $account_id as a 
L<WWW::Ohloh::API::Account>
object. If no such account exists, an error is thrown.
The $accound_id can either be specified as the Ohloh id number, 
or the email address associated with the account.

    my $account = $ohloh->fetch_account( 12933 );
    my $other_accound = $ohloh->fetch_account( 'foo@bar.com' );


=head2 fetch_project( $id )

Return the project having the Ohloh id I<$id> as a
L<WWW::Ohloh::API::Project>.  If no such project exists, 
an error is thrown.

    my $project = $ohloh->fetch_project( 1234) ;
    print $project->name;

=head2 fetch_projects( query => $query, sort => $sorting_order, max => $nbr )

Return a set of projects as a L<WWW::Ohloh::API::Projects> object. 

=head3 Parameters

=over

=item query

If provided, only the projects matching the query string are returned.
A project matches the query string is any of its name, description
or tags does.

=item sort

If provided, the projects will be returned according to the specified 
sorting order.  Valid values are 
'created_at', 'description', 'id', 'name', 'stack_count',
'updated_at', 'created_at_reverse',
'description_reverse', 'id_reverse', 'name_reverse',
'stack_count_reverse' or 'updated_at_reverse'.  If no sorting order
is explicitly given, 'id' is the default.

=item max

If given, the project set will returns at most I<$nbr> projects.

    # get top ten stacked projects
    my @top = $ohloh->fetch_projects( max => 10, sort => 'stack_count' )->all;

=back

=head2 fetch_languages( sort => $order )

Return the languages known to Ohloh a set of L<WWW::Ohloh::API::Language>
objects. 

An optional I<sort> parameter can be passed to the method. The valid
I<$order>s it accepts are
C<total>, C<code>, C<projects>, C<comment_ratio>, 
C<contributors>, C<commits> and C<name>. If I<sort> is not explicitly called,
projects are returned in alphabetical order of C<name>s.

=head2 fetch_activity_facts( $project_id, $analysis )

Return a set of activity facts computed out of the project associated
with the I<$project_id> as a L<WWW::Ohloh::API::ActivityFacts> object. 

The optional argument I<$analysis> can be either an Ohloh analysis id 
(which must be an analysis associated to the project) or the keyword
'latest'. By default the latest analysis will be queried.

=head2 fetch_contributor_language_facts( project_id => $p_id,  contributor_id => $c_id )

    my @facts = $ohloh->fetch_contributor_language_facts(
        project_id     => 1234,
        contributor_id => 5678
    );

Return the list of contributor language facts associated to the 
contributor I<$c_id> for the project I<$p_id>.

=head2 fetch_enlistments( project_id => $id )

Returns the list of enlistements pertaining to the
given project as an L<WWW::Ohloh::API::Enlistment> object.

    my $enlistments = $ohloh->fetch_enlistments( project_id => 1234 );

    while ( my $enlistment = $enlistments->next ) {
        # do stuff with $enlistment...
    }

=head2 fetch_size_facts( $project_id, $analysis_id )

Return the list of L<WWW::Ohloh::API::SizeFact> objects pertaining to the
given project and analysis. If I<$analysis_id> is not provided, it defaults
to the latest analysis done on the project.

=head2 fetch_project_stacks( $project_id ) 

Returns the list of stacks containing the project as 
L<WWW::Ohloh::API::Stack>
objects.

=head2 fetch_account_stack( $account_id )

Returns the stack associated with the account as an 
L<WWW::Ohloh::API::Stack> object.

=head2 fetch_kudos( $account_id )

Returns the kudos associated with the given account 
(the id can be either the numerical id or the account's
email address) as a list of L<WWW::Ohloh::API::Kudo> objects.

    my @kudos = $ohloh->fetch_kudos( 12345 );

=head2 fetch_messages( [ account | project ] => I<$id> )

Returns the messages associated to the given account or project
as a L<WWW::Ohloh::API::Messages> object.

=head1 SEE ALSO

=over

=item *

L<WWW::Ohloh::API::Project>, 
L<WWW::Ohloh::API::Projects>, 
L<WWW::Ohloh::API::Account>, 
L<WWW::Ohloh::API::KudoScore>,
L<WWW::Ohloh::API::Languages>,
L<WWW::Ohloh::API::Language>.

=item *

Ohloh API reference: http://www.ohloh.net/api/getting_started

=item * 

How to obtain an Ohloh API key: http://www.ohloh.net/api_keys/new

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

