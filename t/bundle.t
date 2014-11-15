use strict;
use warnings;
use Test::More;
use File::Path 'remove_tree';

my $script = 'bin/implode';
my $out    = 'out.pl';
plan skip_all => "Cannot test without $script" unless -x $script;
plan skip_all => "Cannot test without Mojolicious" unless eval 'require Mojo::Util;1' or $ENV{FORCE_TEST};

$script = do $script or die "do $script: $@";
$script = bless {verbose => $ENV{HARNESS_IS_VERBOSE}, tmpdir => 'tmp'}, $script;

chdir 't/data' or die "Could not chdir t/tmp: $!";
remove_tree 'tmp';
unlink $out;
$script = bless {verbose => $ENV{HARNESS_IS_VERBOSE}, tmpdir => 'tmp'}, 'App::implode::cli';

eval { $script->run('test.pl'); };
like $@, qr{already exists}, 'already exists';

is $script->run('test.pl' => $out), 0, 'imploded test.pl';
ok -s $out, "created $out";
ok -x $out, "can execute $out";
is system(perl => -c => $out), 0, "can compile $out";

system("head -n 6 $out") if $ENV{HARNESS_IS_VERBOSE};
ok !-d '/tmp/app-implode-out.pl', '/tmp/app-implode-out.pl was cleaned up';

unlink $out;
done_testing;
