package WWW::Ohloh::API::Object::KudoScore;
# ABSTRACT: an Ohloh kudo score

use strict;
use warnings;

use Moose;

use MooseX::SemiAffordanceAccessor;
use WWW::Ohloh::API::Role::Attr::XMLExtract;

with qw/ 
    WWW::Ohloh::API::Role::Fetchable
/;

=method kudo_rank

Returns the kudo rank, which is an integer from 1 to 10.

=method position

Returns an integer which orders all participants. 
The person with `position` equals 1 is the highest-ranked person on Ohloh.

=cut

has [qw/ kudo_rank position /] => (
    traits => [ 'WWW::Ohloh::API::Role::Attr::XMLExtract' ],
    isa => 'Int',
    is => 'rw',
);

1;

__END__


=head1 SYNOPSIS

    use WWW::Ohloh::API;

    my $ohloh = WWW::Ohloh::API->new( api_key => $my_api_key );
    my $account = $ohloh->fetch( Account => id => 12933 );
    my $kudo = $account->kudo_score;

    print $kudo->kudo_rank;

=head1 DESCRIPTION

C<WWW::Ohloh::API::Object::KudoScore>
contains the kudo information associated with an Ohloh 
account as defined at <http://www.ohloh.net/api/reference/kudo_score>. 

