use strict;
use warnings;
no warnings qw/ uninitialized /;

use Test::More;

use WWW::Ohloh::API;
use Data::Printer;

plan skip_all =>
  "set TEST_OHLOH_ACCOUNT to a valid ohloh email address "
  . "to enable these tests"
  unless $ENV{TEST_OHLOH_ACCOUNT};

plan skip_all => <<'END_MSG', 1 unless $ENV{OHLOH_KEY};
set the environment variable OHLOH_KEY to your api key to enable these tests
END_MSG

my $ohloh = WWW::Ohloh::API->new( debug => 1, api_key => $ENV{OHLOH_KEY} );

my $account = $ohloh->fetch( Account => email => $ENV{TEST_OHLOH_ACCOUNT} );

diag "url: ", $account->request_url;
diag "result: \n", $account->xml_src->toString;

ok $account, "account exists";

my $time_regex  = qr/ ^ \d{4}-\d{1,2}-\d{1,2}T[0-9:]+\w $ /x;
my $href_regex  = qr/ ^ ( https?:.*? )? $ /x;
my $coord_regex = qr/ ^ (-? \d+ \. \d+)? $ /x;

like $account->request_url =>
  qr#http://www.ohloh.net/accounts/\w+.xml\?v=1&api_key=\w+#,
  'request url';
like $account->id   => qr/ ^ \d+ $ /x, 'id';
like $account->name => qr/ ^ .+ $ /x,  'name';
isa_ok $account->$_ => 'DateTime' for qw/ created_at updated_at /;
like $account->homepage_url => $href_regex, "homepage url";
like $account->avatar_url =>
  qr#^(http://www.gravatar.com/avatar.php\?gravatar_id=[0-9A-Fa-f]+)?$#,
  "avatar url";
like $account->posts_count => qr#^\d+$#, 'posts count';

#like $account->location     => 'Ottawa, ON, Canada', 'location';
#like $account->country_code => 'CA',                 "country code";
like $account->latitude  => $coord_regex, "latitude";
like $account->longitude => $coord_regex, "longitude";

if( my $kudo = $account->kudo_score ) {
    like $kudo->kudo_rank      => qr/^\d+$/,   'kudo rank';
    like $kudo->position       => qr/^\d+$/,   'kudo position';
}

done_testing;
