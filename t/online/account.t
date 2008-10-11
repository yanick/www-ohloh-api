use strict;
use warnings;
no warnings qw/ uninitialized /;

use Test::More;    # last test to print

use WWW::Ohloh::API;

plan skip_all =>
  "set TEST_OHLOH_ACCOUNT to a valid ohloh account id or email address "
  . "to enable these tests"
  unless $ENV{TEST_OHLOH_ACCOUNT};

plan skip_all => <<'END_MSG', 1 unless $ENV{OHLOH_KEY};
set the environment variable OHLOH_KEY to your api key to enable these tests
END_MSG

plan 'no_plan';

my $ohloh = WWW::Ohloh::API->new( api_key => $ENV{OHLOH_KEY} );

my $account = $ohloh->fetch_account( $ENV{TEST_OHLOH_ACCOUNT} );

ok $account, "account exists";

my $time_regex  = qr/ ^ \d{4}-\d{1,2}-\d{1,2}T[0-9:]+\w $ /x;
my $href_regex  = qr/ ^ ( https?:.*? )? $ /x;
my $coord_regex = qr/ ^ (-? \d+ \. \d+)? $ /x;

like $account->request_url =>
  qr#http://www.ohloh.net/accounts/\w+.xml\?v=1&api_key=\w+#,
  'request url';
like $account->id   => qr/ ^ \d+ $ /x, 'id';
like $account->name => qr/ ^ .+ $ /x,  'name';
isa_ok $account->$_ => 'Time::Piece' for qw/ created_at updated_at /;
like $account->homepage_url => $href_regex, "homepage url";
like $account->avatar_url =>
  qr#^(http://www.gravatar.com/avatar.php\?gravatar_id=[0-9A-Fa-f]+)?$#,
  "avatar url";
like $account->posts_count => qr#^\d+$#, 'posts count';

#like $account->location     => 'Ottawa, ON, Canada', 'location';
#like $account->country_code => 'CA',                 "country code";
like $account->latitude  => $coord_regex, "latitude";
like $account->longitude => $coord_regex, "longitude";

my $kudo = $account->kudo_score;

SKIP: {
    skip "user doesn't have kudos", 99 unless $kudo;

    like $kudo->created_at => $time_regex, 'kudo created at';
    like $kudo->kudo_rank      => qr/^\d+$/,   'kudo rank';
    like $kudo->position       => qr/^\d+$/,   'kudo position';
    like $kudo->max_position   => qr/^\d+$/,   'kudo max_position';
    like $kudo->position_delta => qr/^-?\d+$/, 'kudo position_delta';

}
