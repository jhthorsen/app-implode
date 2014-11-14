use strict;
use warnings;
use Test::More;
use File::Path 'remove_tree';

my $script = 'bin/implode';
plan skip_all => "Cannot test without $script" unless -x $script;
plan skip_all => "Cannot test without Mojolicious" unless eval 'require Mojo::Util;1' or $ENV{FORCE_TEST};

$script = do $script or die "do $script: $@";
is $script, 'App::implode::cli', 'implode loaded';

chdir 't/data' or die "Could not chdir t/tmp: $!";
remove_tree 'tmp' unless $ENV{KEEP_FILES};
$script = bless {silent => !$ENV{HARNESS_IS_VERBOSE},tmpdir => 'tmp'}, 'App::implode::cli';

eval { $script->run; };
like $@, qr{Usage:}, 'usage';

eval { $script->run('foo'); };
like $@, qr{Cannot read}, 'invalid script';

eval { $script->run('test.pl'); };
like $@, qr{already exists}, 'already exists';

is $script->run('test.pl' => 'out.pl'), 0, 'imploded test.pl';

$script->bundle;

remove_tree 'tmp' unless $ENV{KEEP_FILES};
done_testing;
