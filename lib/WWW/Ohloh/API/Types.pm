package WWW::Ohloh::API::Types;

use strict;
use warnings;

use MooseX::Types -declare => [ qw/
    OhlohId
    OhlohDate
    OhlohURI
/ ];

use Digest::MD5 qw/ md5_hex /;
use DateTime::Format::W3CDTF;

use MooseX::Types::Moose qw/ Int Str /;
use MooseX::Types::DateTime::ButMaintained qw/ DateTime /;
use MooseX::Types::URI qw/ Uri /;
use URI;

class_type OhlohURI, { class => 'URI' };

coerce OhlohURI,
    from Str,
    via { URI->new($_) };

subtype OhlohId,
    as Int,
    where { /^\d+/ or index( $_, '@' ) > -1 },
    message { "'$_' is not an id number or an email address"  } ;

coerce OhlohId, from Int,  via { $_ };
coerce OhlohId, from Str, via { md5_hex( $_ ) };

subtype OhlohDate,
    as DateTime;

coerce OhlohDate,
    from Str,
    via { DateTime::Format::W3CDTF->new->parse_datetime($_) };

1;

