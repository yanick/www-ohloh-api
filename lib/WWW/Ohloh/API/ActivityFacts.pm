package WWW::Ohloh::API::ActivityFacts;

use strict;
use warnings;

use Carp;
use Object::InsideOut;
use XML::LibXML;
use Readonly;
use List::MoreUtils qw/ any /;
use WWW::Ohloh::API::ActivityFact;

our $VERSION = '0.0.3';

my @ohloh_of      :Field  :Arg(ohloh);
my @project_of    :Field  :Arg(project);
my @analysis_of   :Field  :Arg(analysis);
my @facts_of      :Field;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub _init :Init {
    my $self = shift;

    my( $url, $xml ) = $ohloh_of[ $$self ]->_query_server( 
         "projects/$project_of[ $$self ]/analyses/"
        ."$analysis_of[ $$self ]/activity_facts.xml"
    );

    $facts_of[ $$self ] = [ map { WWW::Ohloh::API::ActivityFact->new( xml => $_ ) }
                                 $xml->findnodes( 'activity_fact' ) ];

    return;
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub as_xml { 
    my $self = shift; 
    my $xml;
    my $w = XML::Writer->new( OUTPUT => \$xml );

    $w->startTag( 'languages' );
   
    $w->endTag;

    return $xml; 
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub all {
    my $self = shift;

    return @{ $facts_of[ $$self ] };
}

'end of WWW::Ohloh::API::ActivityFacts';
__END__

=head1 NAME

WWW::Ohloh::API::Languages - a set of languages as known by Ohloh

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

Return the retrieved languages' information as
L<WWW::Ohloh::API::Language> objects.

=head3 as_xml

Return the languages' information 
as an XML string.  Note that this is not the exact xml document as returned
by the Ohloh server. 

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

This document describes WWW::Ohloh::API version 0.0.3

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


