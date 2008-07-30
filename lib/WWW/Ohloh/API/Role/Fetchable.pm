package WWW::Ohloh::API::Role::Fetchable;

use strict;
use warnings;

use Object::InsideOut;

use Carp;
use URI;

our $VERSION = '0.2.0';

#<<<
my @request_url_of  : Field 
                    : Arg(Name => 'request_url', Preproc => \&WWW::Ohloh::API::Role::Fetchable::process_url) 
                    : Get(request_url) 
                    : Type(URI);
my @ohloh_of        : Field 
                    : Arg(ohloh) 
                    : Set(set_ohloh) 
                    : Get(ohloh);
#>>>
sub process_url {
    my $value = $_[4];

    return URI->new($value);
}

1;
