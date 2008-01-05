use strict;
use warnings;

use Test::More qw/ no_plan /;    # last test to print

use WWW::Ohloh::API;
use XML::LibXML;

# fake the online request

masquerade_server_query(
    'http://www.ohloh.net/accounts/12933.xml?v=1&api_key=myapikey',
    <<'END_XML' );
  <result>
    <account>
      <id>12933</id>
      <name>Yanick</name>
      <created_at>2007-12-30T18:39:18Z</created_at>
      <updated_at>2008-01-03T14:53:18Z</updated_at>
      <homepage_url></homepage_url>
      <avatar_url>http://www.gravatar.com/avatar.php?gravatar_id=a15c336550dd22cbdff9743a54b56b3b</avatar_url>
      <posts_count>613</posts_count>
      <location>Ottawa, ON, Canada</location>
      <country_code>CA</country_code>
      <latitude>45.423494</latitude>
      <longitude>-75.697933</longitude>
      <kudo_score>
        <created_at>2008-01-03T05:16:25Z</created_at>
        <kudo_rank>7</kudo_rank>
        <position>8684</position>
        <max_position>84400</max_position>
        <position_delta>-56</position_delta>
      </kudo_score>
    </account>
  </result>
END_XML

my $ohloh = WWW::Ohloh::API->new;
my $account = $ohloh->get_account( id => 12933 );

is $account => 'Yanick', 'overloading';

like $account->as_xml => qr# ^ \s* <account> .* </account> \s* $ #sx, 'as_xml()';

is $account->request_url =>
    'http://www.ohloh.net/accounts/12933.xml?v=1&api_key=myapikey',
    'request url';
is $account->id           => 12933,                  'id';
is $account->name         => 'Yanick',               'name';
is $account->created_at   => '2007-12-30T18:39:18Z', 'created at';
is $account->updated_at   => '2008-01-03T14:53:18Z', 'updated at';
is $account->homepage_url => '',                     "homepage url";
is $account->avatar_url =>
    'http://www.gravatar.com/avatar.php?gravatar_id=a15c336550dd22cbdff9743a54b56b3b',
    "avatar url";
is $account->posts_count  => 613,                  'posts count';
is $account->location     => 'Ottawa, ON, Canada', 'location';
is $account->country_code => 'CA',                 "country code";
is $account->latitude     => '45.423494',          "latitude";
is $account->longitude    => '-75.697933',         "longitude";

my $kudo = $account->kudo_score;
ok $kudo, "kudo score";

is $kudo->created_at     => '2008-01-03T05:16:25Z', 'kudo created at';
is $kudo->kudo_rank      => '7',                    'kudo rank';
is $kudo->rank           => '7',                    'kudo rank (short)';
is $kudo->position       => '8684',                 'kudo position';
is $kudo->max_position   => '84400',                'kudo max_position';
is $kudo->position_delta => '-56',                  'kudo position_delta';

like $kudo->as_xml => qr# ^ \s* <kudo_score> .* </kudo_score> \s* $ #sx, 'kudo as_xml()';

### utility functions ######################################

sub masquerade_server_query {
    my ( $url, $xml ) = @_;
    no warnings;    # it's naughty stuff, but for a good cause
    my $parser = XML::LibXML->new;
    my $dom = $parser->parse_string( $xml );
    eval {
        sub WWW::Ohloh::API::_query_server {
            return $url, $dom->findnodes( '//result[1]' );
        }
    };
}
