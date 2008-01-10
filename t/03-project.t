use strict;
use warnings;

use Test::More qw/ no_plan /;        # last test to print
use WWW::Ohloh::API;
use XML::LibXML;

masquerade_server_query(
    'http://www.ohloh.net/projects/10706.xml?v=1&api_key=myapikey',
    <<'END_XML' );
  <result>
    <project>
      <id>10716</id>
      <name>WWW::Ohloh::API</name>
      <created_at>2008-01-03T20:55:40Z</created_at>
      <updated_at>2008-01-03T21:20:21Z</updated_at>
      <description>A Perl interface to the Ohloh API as defined at http://www.ohloh.net/api/getting_started.</description>
      <homepage_url>http://search.cpan.org/search%3fmodule=WWW::Ohloh::API</homepage_url>
      <download_url>http://search.cpan.org/search%3fmodule=WWW::Ohloh::API</download_url>
      <irc_url/>
      <stack_count>1</stack_count>
      <average_rating>0.0</average_rating>
      <rating_count>0</rating_count>
      <analysis_id>100430</analysis_id>
      <analysis>
        <id>100430</id>
        <project_id>10716</project_id>
        <updated_at>2008-01-03T21:20:21Z</updated_at>
        <logged_at>2008-01-03T20:59:39Z</logged_at>
        <min_month>2008-01-01T00:00:00Z</min_month>
        <max_month>2008-01-01T00:00:00Z</max_month>
        <twelve_month_contributor_count>1</twelve_month_contributor_count>
        <total_code_lines>381</total_code_lines>
        <main_language_id>8</main_language_id>
        <main_language_name>Perl</main_language_name>
      </analysis>
    </project>
  </result>
END_XML

my $ohloh = WWW::Ohloh::API->new;

my $p = $ohloh->get_project( 10716 );

like $p->as_xml => qr#<project>.*</project>#s, 'as_xml';

is $p->id   => 10716, 'id';
is $p->name => 'WWW::Ohloh::API', 'name';
is $p->created_at => '2008-01-03T20:55:40Z', 'created_at';
is $p->updated_at => '2008-01-03T21:20:21Z', 'updated at';
like $p->description => qr/A Perl interface/, 'description';
is $p->homepage_url =>
'http://search.cpan.org/search%3fmodule=WWW::Ohloh::API', 'homepage';
is $p->download_url =>
'http://search.cpan.org/search%3fmodule=WWW::Ohloh::API', 'download';
is $p->irc_url => '', 'irc';
is $p->stack_count => 1, 'stack count';
is $p->average_rating + 0 => 0, 'average rating';
is $p->rating_count => 0, 'rating count';
is $p->analysis_id => 100430, 'analysis id';

my $a = $p->analysis;

is $a->id => 100430, "analysis id";
is $a->project_id => $p->id, "analysis project id";
is $a->updated_at => '2008-01-03T21:20:21Z', "analysis updated_at";
is $a->logged_at => '2008-01-03T20:59:39Z', "analysis logged_at";
is $a->min_month => '2008-01-01T00:00:00Z', "analysis min_month";
is $a->max_month => '2008-01-01T00:00:00Z', "analysis max_month";
is $a->twelve_month_contributor_count => 1, "analysis 12_month_cont";
is $a->total_code_lines => 381, "analysis code lines";
is $a->main_language_id => 8, 'analysis main lang id';
is $a->main_language_name => 'Perl', 'analysis main lang name';
is $a->main_language => 'Perl', 'analysis main lang';
is $a->language => 'Perl', 'analysis lang';

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
