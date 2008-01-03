use strict;
use warnings;

use Test::More tests => 5;                      # last test to print

use WWW::Ohloh::API;
use XML::Simple;

my $ohloh = WWW::Ohloh::API->new;

ok $ohloh, 'object creation';

$ohloh->set_api_key( 'mykey' );

is $ohloh->get_api_key => 'mykey', 'set/get_api_key';

$ohloh = WWW::Ohloh::API->new( api_key => 'myotherkey' );

is $ohloh->get_api_key => 'myotherkey', 'set api key from new()';


SKIP: {

    skip <<'END_MSG', 1 unless $ENV{OHLOH_KEY};
online tests, to enable set the environment variable OHLOH_KEY to your api key
END_MSG

    $ohloh->set_api_key( $ENV{OHLOH_KEY} );
    ok $ohloh->get_account( id => 12933 );

}

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
      <posts_count>0</posts_count>
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

sub masquerade_server_query {
    my( $url, $xml ) = @_;
    eval { 
        sub WWW::Ohloh::API::_query_server {
            return $url, XMLin( $xml );
        } 
    };
}
