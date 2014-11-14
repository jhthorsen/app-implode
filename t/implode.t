use strict;
use warnings;
use Test::More;
use File::Path 'remove_tree';

my $script = 'bin/implode';
plan skip_all => "Cannot test without $script" unless -x $script;
plan skip_all => "Cannot test without Mojolicious" unless eval 'require Mojo::Util;1' or $ENV{FORCE_TEST};

$script = do $script or die "do $script: $@";
is $script, 'App::implode::cli', 'implode loaded';
$script = bless {silent => !$ENV{HARNESS_IS_VERBOSE}, tmpdir => 'tmp'}, $script;

eval { $script->run; };
like $@, qr{Usage:}, 'usage';

eval { $script->run('foo'); };
like $@, qr{Cannot read}, 'invalid script';

ok !$script->dir_is_empty('t'), 'not empty: t';
ok $script->dir_is_empty('/nakjdsnlkjad8123nlkjansdad'), 'empty: /nakjdsnlkjad8123nlkjansdad';
mkdir 'exists-but-is-empty';
ok $script->dir_is_empty('exists-but-is-empty'), 'empty: exists-but-is-empty';
rmdir 'exists-but-is-empty';

my $guard = $script->chdir('t');
ok !-e $0, "chdir";
undef $guard;
ok -e $0, "chdir DESTROY";

done_testing;
