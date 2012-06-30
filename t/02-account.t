use strict;
use warnings;

use Test::More qw/ no_plan /;

use WWW::Ohloh::API::Test;
use Scalar::Util 'refaddr';

my $ohloh = WWW::Ohloh::API::Test->new( api_key => 'myapikey' );

$ohloh->stash_file( 
    'http://www.ohloh.net/accounts/12933.xml?v=1&api_key=myapikey'
        => 't/samples/account.xml' );

my $account = $ohloh->fetch( 'Account' => id => 12933 );
is ''.$account => 'Yanick', 'overloading';

is $account->request_url =>
  'http://www.ohloh.net/accounts/12933.xml?v=1&api_key=myapikey',
  'request url';
is $account->id   => 12933,    'id';
is $account->name => 'Yanick', 'name';

is $account->created_at->year => '2007';
isa_ok $account->created_at => 'DateTime';
is $account->created_at => '2007-12-30T18:39:18';
is $account->updated_at     => '2012-06-25T23:40:19', 'updated at';
is $account->homepage_url   => '', "homepage url";
is $account->avatar_url =>
  'http://www.gravatar.com/avatar.php?gravatar_id=a15c336550dd22cbdff9743a54b56b3b',
  "avatar url";
is $account->posts_count  => 10,                  'posts count';
is $account->location     => 'Ottawa, ON, Canada', 'location';
is $account->country_code => 'CA',                 "country code";
is $account->latitude     => '45.423494',          "latitude";
is $account->longitude    => '-75.697933',         "longitude";

my $kudo = $account->kudo_score;
ok $kudo, "kudo score";

is $kudo->kudo_rank      => '9',                    'kudo rank';
is $kudo->position       => '7408',                 'kudo position';

# stack

my $stack = $account->stack;

isa_ok $stack, 'WWW::Ohloh::API::Object::Stack';

is refaddr( $stack->account ) => refaddr($account), "account is passed";


