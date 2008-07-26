package WWW::Ohloh::API::Role::Fetchable;

use strict;
use warnings;

use Object::InsideOut;
use Carp;

our $VERSION = '0.1.0';

my @request_url_of : Field : Arg(request_url) : Get( request_url );
my @ohloh_of : Field : Arg(ohloh) : Set( set_ohloh ) : Get(ohloh);

1;
