use strict;
use warnings;

use Test::More tests => 1;    # last test to print

use WWW::Ohloh::API;
use Exception::Class;

### online stuff ###########################################

SKIP: {
    skip <<'END_REASON', 1 unless $ENV{OHLOH_KEY};
set the environment variable OHLOH_KEY to your api key to enable these tests
END_REASON

}

pass;
