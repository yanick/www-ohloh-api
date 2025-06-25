use 5.006;
use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.058

use Test::More;

plan tests => 27 + ($ENV{AUTHOR_TESTING} ? 1 : 0);

my @module_files = (
    'WWW/Ohloh/API.pm',
    'WWW/Ohloh/API/Account.pm',
    'WWW/Ohloh/API/ActivityFact.pm',
    'WWW/Ohloh/API/ActivityFacts.pm',
    'WWW/Ohloh/API/Analysis.pm',
    'WWW/Ohloh/API/Collection.pm',
    'WWW/Ohloh/API/ContributorFact.pm',
    'WWW/Ohloh/API/ContributorLanguageFact.pm',
    'WWW/Ohloh/API/Enlistment.pm',
    'WWW/Ohloh/API/Enlistments.pm',
    'WWW/Ohloh/API/Factoid.pm',
    'WWW/Ohloh/API/Kudo.pm',
    'WWW/Ohloh/API/KudoScore.pm',
    'WWW/Ohloh/API/Kudos.pm',
    'WWW/Ohloh/API/Language.pm',
    'WWW/Ohloh/API/Languages.pm',
    'WWW/Ohloh/API/Message.pm',
    'WWW/Ohloh/API/Message/Tag.pm',
    'WWW/Ohloh/API/Messages.pm',
    'WWW/Ohloh/API/Project.pm',
    'WWW/Ohloh/API/Projects.pm',
    'WWW/Ohloh/API/Repository.pm',
    'WWW/Ohloh/API/Role/Fetchable.pm',
    'WWW/Ohloh/API/Role/LoadXML.pm',
    'WWW/Ohloh/API/SizeFact.pm',
    'WWW/Ohloh/API/Stack.pm',
    'WWW/Ohloh/API/StackEntry.pm'
);



# no fake home requested

my @switches = (
    -d 'blib' ? '-Mblib' : '-Ilib',
);

use File::Spec;
use IPC::Open3;
use IO::Handle;

open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    my $stderr = IO::Handle->new;

    diag('Running: ', join(', ', map { my $str = $_; $str =~ s/'/\\'/g; q{'} . $str . q{'} }
            $^X, @switches, '-e', "require q[$lib]"))
        if $ENV{PERL_COMPILE_TEST_DEBUG};

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, @switches, '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$lib loaded ok");

    shift @_warnings if @_warnings and $_warnings[0] =~ /^Using .*\bblib/
        and not eval { +require blib; blib->VERSION('1.01') };

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found')
    or diag 'got warnings: ', ( Test::More->can('explain') ? Test::More::explain(\@warnings) : join("\n", '', @warnings) ) if $ENV{AUTHOR_TESTING};


