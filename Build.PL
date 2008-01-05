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
        'LWP::UserAgent' => 0,
        'Readonly' => 0,
        'XML::Simple' => 0,
        'Object::InsideOut' => 0,
        'Digest::MD5' => 0,
        'XML::Writer' => 0,
    },
    add_to_cleanup      => [ 'WWW-Ohloh-API-*' ],
    create_makefile_pl => 'passthrough',
);

$builder->create_build_script();
