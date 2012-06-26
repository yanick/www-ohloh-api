package WWW::Ohloh::API::Types;

use strict;
use warnings;

use Digest::MD5 qw/ md5_hex /;

use MooseX::Types -declare => [ qw/
    OhlohId
/ ];

use MooseX::Types::Moose qw/ Int Str /;

subtype OhlohId,
    as Int,
    where { /^\d+/ or index( $_, '@' ) > -1 },
    message { "'$_' is not an id number or an email address"  } ;

coerce OhlohId, from Int,  via { $_ };
coerce OhlohId, from Str, via { md5_hex( $_ ) };

1;

