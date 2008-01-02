use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WWW::Ohloh::API',
    license             => 'perl',
    dist_author         => 'Yanick Champoux <yanick@cpan.org>',
    dist_version_from   => 'lib/WWW/Ohloh/API.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'WWW-Ohloh-API-*' ],
);

$builder->create_build_script();
