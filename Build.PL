use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'WWW::Ohloh::API',
    license           => 'perl',
    dist_author       => 'Yanick Champoux <yanick@cpan.org>',
    dist_version_from => 'lib/WWW/Ohloh/API.pm',
    requires          => {
        perl                  => '5.8.0',
        'Test::More'          => 0,
        'version'             => 0,
        'LWP::UserAgent'      => 0,
        'Readonly'            => 0,
        'Object::InsideOut'   => 0,
        'Digest::MD5'         => 0,
        'XML::Writer'         => 0,
        'XML::LibXML'         => 0,
        'URI'                 => 0,
        'HTML::HeadParser'    => 0,
        'Params::Validate'    => 0,
        'List::MoreUtils'     => 0,
        URI                   => 0,
        'Date::Parse'         => 0,
        'Time::Piece'         => 0,
    },
    recommends => {
        'Test::Pod::Snippets' => '0.04.01',
    },
    add_to_cleanup     => ['WWW-Ohloh-API-*'],
    create_makefile_pl => 'passthrough',
    meta_merge => {
        resources => {
            repository => 'http://babyl.dyndns.org/git/www-ohloh-api.git',
            bugtracker =>
            'http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Ohloh-Api',
        },
    },
);

$builder->create_build_script();
