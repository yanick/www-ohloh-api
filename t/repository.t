use strict;
use warnings;

use Test::More tests => 9;    # last test to print

use XML::LibXML;
use WWW::Ohloh::API::Repository;

my $parser = XML::LibXML->new;

my $xml = $parser->parse_file('t/samples/enlistments.xml');

my $rep =
  WWW::Ohloh::API::Repository->new(
    xml => $xml->findnodes('//repository[1]') );

isa_ok $rep => 'WWW::Ohloh::API::Repository';

my %method = (
    id               => '19724',
    type             => 'GitRepository',
    url              => 'http://babyl.dyndns.org/git/www-ohloh-api.git',
    username         => '',
    password         => '',
    logged_at        => '2008-02-04T17:31:43Z',
    commits          => 8,
    ohloh_job_status => 'success',
);

for my $m ( keys %method ) {
    is $rep->$m => $method{$m}, "$m()";
}

