#!perl
# vim:ts=4:sw=4:expandtab
#
# Please read the following documents before working on tests:
# • http://build.i3wm.org/docs/testsuite.html
#   (or docs/testsuite)
#
# • http://build.i3wm.org/docs/lib-i3test.html
#   (alternatively: perldoc ./testcases/lib/i3test.pm)
#
# • http://build.i3wm.org/docs/ipc.html
#   (or docs/ipc)
#
# • http://onyxneon.com/books/modern_perl/modern_perl_a4.pdf
#   (unless you are already familiar with Perl)
#
# Verifies that "move container to output" works correctly when
# used with command criteria.
# Bug still in: 4.10.4-349-gee5db87
use i3test i3_autostart => 0;

my $config = <<EOT;
# i3 config file (v4)
font pango:monospace 8

fake-outputs 800x600+0+0,800x600+800+0,800x600+0+600,800x600+800+600
EOT

my $pid = launch_with_config($config);

my $ws_top_left = fresh_workspace(output => 0);
my $ws_top_right = fresh_workspace(output => 1);
my $ws_bottom_left = fresh_workspace(output => 2);
my $ws_bottom_right = fresh_workspace(output => 3);

cmd "workspace " . $ws_top_left;
open_window(wm_class => 'moveme');
cmd "workspace " . $ws_bottom_left;
open_window(wm_class => 'moveme');

cmd '[class="moveme"] move window to output right';

is_num_children($ws_top_left, 0, 'no containers on the upper left workspace');
is_num_children($ws_top_right, 1, 'one container on the upper right workspace');
is_num_children($ws_bottom_left, 0, 'no containers on the lower left workspace');
is_num_children($ws_bottom_right, 1, 'one container on the lower right workspace');

exit_gracefully($pid);

done_testing;
