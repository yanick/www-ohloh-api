package WWW::Ohloh::API::Types;

use Digest::MD5 qw/ md5_hex /;

use MooseX::Types -declare => [ qw/
    Date
    Ohloh_Id
/ ];

use MooseX::Types::Moose qw/ Object Str Int Any /;

use Time::Piece;
use Date::Parse;

subtype Date,
    as Object,
    where { $_->isa( 'Time::Piece' ) };

coerce Date,
    from Str,
    via { Time::Piece::gmtime( str2time( $_ ) ) };

subtype Ohloh_Id,
    as 'Str|Int',
    where { /^\d+/ or index( $_, '@' ) > -1 },
    message { "'$_' is not an id number or an email address"  } ;

coerce Ohloh_Id, from Any, via { md5_hex( $_ ) };
coerce Ohloh_Id, from Int,  via { $_ };

1;

