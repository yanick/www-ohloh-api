#!/usr/bin/perl 

use strict;
use warnings;

use WWW::Ohloh::API;

my $ohloh = WWW::Ohloh::API->new( debug => 1, api_key => $ENV{OHLOH_KEY} );

$ohloh->_query_server( shift );



