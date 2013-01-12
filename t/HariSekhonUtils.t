#
#   Author: Hari Sekhon
#   Date: 2013-01-06 01:25:55 +0000 (Sun, 06 Jan 2013)
#  $LastChangedBy$
#  $LastChangedDate$
#  $Revision$
#  $URL$
#  $Id$
#
#  vim:ts=4:sw=4:et

# Unit Tests for HariSekhonUtils

use diagnostics;
use warnings;
use strict;
use Test::More;
use lib ".";

BEGIN{ use_ok('HariSekhonUtils'); }
require_ok('HariSekhonUtils');

ok($progname,   '$progname set');

# ============================================================================ #
#                           Status Codes
# ============================================================================ #

is($ERRORS{"OK"},        0, '$ERRORS{OK}        eq 0');
is($ERRORS{"WARNING"},   1, '$ERRORS{WARNING}   eq 1');
is($ERRORS{"CRITICAL"},  2, '$ERRORS{CRITICAL}  eq 2');
is($ERRORS{"UNKNOWN"},   3, '$ERRORS{UNKNOWN}   eq 3');
is($ERRORS{"DEPENDENT"}, 4, '$ERRORS{DEPENDENT} eq 4');
is($port, undef, "port is undef");

ok(set_timeout_max(200),     "set_timeout_max(200)");
is($timeout_max, 200, '$timeout_max eq 200');
ok(set_timeout_default(100), "set_timeout_default(100)");
is($timeout_default, 100, '$timeout_default eq 100');

is($status,      "UNKNOWN", '$status eq UNKNOWN');
is(get_status_code($status), 3, 'get_status_code($status) eq UNKNOWN');

$status = "OK";
ok(is_ok,        "is_ok()");
ok(!is_warning,  "is_warning() fail on OK");
ok(!is_critical, "is_critical() fail on OK");
ok(!is_unknown,  "is_unknown() fail on OK");

is(unknown, "UNKNOWN", "unknown()");
ok(is_unknown,   "is_unknown()");
ok(!is_ok,       "is_ok() fail on UNKNOWN");
ok(!is_warning,  "is_warning() fail on UNKNOWN");

ok(!is_critical, "is_critical() fail on UNKNOWN");
is(warning, "WARNING", "warning()");
is(unknown, "",  "unknown() doesn't set \$status when WARNING");
ok(is_warning,   "is_warning()");
ok(!is_ok,       "is_ok() fail on WARNING");
ok(!is_critical, "is_critical() fail on WARNING");
ok(!is_unknown,  "is_unknown() fail on WARNING");

is(critical, "CRITICAL", "critical()");
is(unknown, "",  "unknown() doesn't set \$status when CRITICAL");
is(warning, "",  "warning() doesn't set \$status when CRITICAL");
ok(is_critical,  "is_critical()");
ok(!is_ok,       "is_ok() fail on CRITICAL");
ok(!is_warning,  "is_warning() fail on CRITICAL");
ok(!is_unknown,  "is_unknown() fail on CRITICAL");

is(get_status_code("OK"),       0, "get_status_code(OK) eq 0");
is(get_status_code("WARNING"),  1, "get_status_code(WARNING) eq 1");
is(get_status_code("CRITICAL"), 2, "get_status_code(OK) eq 2");
is(get_status_code("UNKNOWN"),  3, "get_status_code(UNKNOWN) eq 3");

$verbose++;
# TODO: This only checks the sub runs and returns success, should really check it outputs the right thing but not sure how to check the stdout from this sub
ok(status(), "status()");

# ============================================================================ #

ok(cmd("ps"), 'cmd("ps");');
#ok(!cmd("unknown_fake_command"), 'cmd("unknown_fake_command");');

is_deeply([compact_array(( "one", "" , "two" ))], [ "one", "two" ], 'compact_array() remove blanks');
is_deeply([compact_array(( "one", "\t\r\n" , "two" ))], [ "one", "two" ], 'compact_array() remove ^\s*$');
is_deeply([compact_array(( "one", 0 , "two" ))], [ "one", 0, "two" ], 'compact_array() not remove zero');

# TODO: check_threshold{,s}, code_error

# TODO: curl onwards
#$verbose = 3;
#use_ok("LWP::Simple", 'get');
#like(curl("http://www.google.com/"), qr/google.com/, 'curl("www.google.com")');

#is(die(), 2, "die() returns 2");

$debug = 1;
ok(debug("debug stuff"), 'debug("debug stuff")');
$debug = 0;
ok(!debug("debug stuff"), '!debug("debug stuff") without \$debug set');

is(expand_units("10", "KB"), 10240, 'expand_units("10", "KB") eq 10240');
is(expand_units("10", "mB"), 10485760, 'expand_units("10", "mB") eq 10485760');
is(expand_units("10", "Gb"), 10737418240, 'expand_units("10", "Gb") eq 10737418240');
is(expand_units("10", "tb"), 10995116277760, 'expand_units("10", "tb") eq 10995116277760');
is(expand_units("10", "Pb"), 11258999068426240, 'expand_units("10", "Pb") eq 11258999068426240');

# TODO: get_options

is(get_path_owner("/etc/passwd"), "root", 'get_path_owner("/etc/passwd") eq "root"');

ok(go_flock_yourself(), "go_flock_yourself()");
ok(flock_off(), "flock_off()");

ok(inArray("one", qw/one two three/), 'inArray("one", qw/one two three/)');
ok(!inArray("four", qw/one two three/), '!inArray("four", qw/one two three/)');

ok(isArray([qw/one two/]), 'isArray([qw/one two/])');
ok(!isArray($verbose),  '!isArray(\$verbose)');

ok(HariSekhonUtils::isCode(sub{}), 'HariSekhonUtils::isCode(sub{})');
ok(HariSekhonUtils::isSub(sub{}), 'HariSekhonUtils::isCode(sub{})');

ok(!HariSekhonUtils::isCode(1), '!HariSekhonUtils::isCode(1)');
ok(!HariSekhonUtils::isSub(1), '!HariSekhonUtils::isSub(1)');

is(isDomain("harisekhon.com"),  "harisekhon.com",   'isDomain("harisekhon.com") eq harisekhon.com');
is(isDomain("harisekhon"),      0,                  '!isDomain("harisekhon") eq 0');
is(isDomain("a"x256),           0,                  '!isDomain("a"x256) eq 0');

is(isEmail('hari\'sekhon@gmail.com'),   'hari\'sekhon@gmail.com',   'isEmail("hari\'sekhon@gmail.com") eq hari\'sekhon@gmail.com');
is(isEmail("harisekhon"),               0,                          '!isEmail("harisekhon") eq 0');

ok(isFloat(1),          'isFloat(1)');
ok(!isFloat(-1),        '!isFloat(-1)');
ok(isFloat(-1, 1),      'isFloat(-1, 1)');

ok(isFloat(1.1),        'isFloat(1.1)');
ok(!isFloat(-1.1),      '!isFloat(-1.1)');
ok(isFloat(-1.1, 1),    'isFloat(-1.1, 1)');

ok(!isFloat("nan"),     '!isFloat("nan")');
ok(!isFloat("nan", 1),  '!isFloat("nan", 1)');

is(isFqdn("hari.sekhon.com"),   "hari.sekhon.com",  'isFqdn("hari.sekhon.com") eq harisekhon.com');
is(isFqdn("harisekhon.com"),    0,                  '!isFqdn("harisekhon.com") eq 0');

# TODO:
#ok(isHash(%{ ( "one" => 1 ) }), "isHash()");

ok(isHex("0xAf09b"), 'isHex');
ok(!isHex(9),        '!isHex(9)');
ok(!isHex("0xhari"), '!isHex("hari")');

is(isHost("harisekhon.com"),    "harisekhon.com",   'isHost("harisekhon.com") eq harisekhon.com');
ok(isHost("harisekhon"),        'isHost("harisekhon")');
ok(isHost("10.10.10.1"),        'isHost("10.10.10.1")');
is(isHost("10.10.10.10"),       "10.10.10.10",      'isHost("10.10.10.10") eq 10.10.10.10');
ok(isHost("10.10.10.100"),      'isHost("10.10.10.100")');
ok(!isHost("10.10.10.0"),       '!isHost("10.10.10.0")');
ok(!isHost("10.10.10.255"),     '!isHost("10.10.10.255")');
ok(!isHost("10.10.10.300"),     '!isHost("10.10.10.300")');
ok(!isHost("a"x256),            '!isHost("a"x256)');

is(isHostname("harisekhon.com"),    "harisekhon.com",   'isHostname("harisekhon.com") eq harisekon.com');
ok(isHostname("harisekhon"),        'isHostname("harisekhon")');
ok(!isHostname(1),                  '!isHostname(1)');
ok(!isHostname("a"x256),            '!isHostname("a"x256)');

ok(isInt(0),    'isInt(0)');
ok(isInt(1),    'isInt(1)');
ok(!isInt(-1),  '!isInt(-1)');
ok(!isInt(1.1), '!isInt(1.1)');
ok(!isInt("a"), '!isInt("a")');

ok(isIP("10.10.10.1"),        'isIP("10.10.10.1")');
is(isIP("10.10.10.10"),       "10.10.10.10",      'isIP("10.10.10.10") eq 10.10.10.10');
ok(isIP("10.10.10.100"),      'isIP("10.10.10.100")');
ok(isIP("254.0.0.254"),       'isIP("254.0.0.254")');
ok(!isIP("10.10.10.0"),       '!isIP("10.10.10.0")');
ok(!isIP("10.10.10.255"),     '!isIP("10.10.10.255")');
ok(!isIP("10.10.10.300"),     '!isIP("10.10.10.300")');
ok(!isIP("x.x.x.x"),          '!isIP("x.x.x.x")');

is(isProcessName("../my_program"),      "../my_program",        'isProcessName("../my_program")');
is(isProcessName("ec2-run-instances"),  "ec2-run-instances",    'isProcessName("ec2-run-instances")');
ok(isProcessName("sh <defunct>"),   'isProcessName("sh <defunct>")');
ok(!isProcessName("./b\@dfile"),    '!isProcessName("./b@dfile")');
ok(!isProcessName("[init] 3"),      '!isProcessName("[init] 3")');

ok(isScalar(\$status),          'isScalar(\$status)');
ok(!isScalar(\@usage_order),    '!isScalar(\@usage_order)');
ok(!isScalar(\%ERRORS),         '!isScalar(\%ERRORS)');
ok(!isScalar(1),                '!isScalar(1)');

is(isUrl("http://www.google.com"),  "http://www.google.com",    'isUrl("http://www.google.com")');
is(isUrl("https://gmail.com"),      "https://gmail.com",        'isUrl("https://gmail.com")');
ok(!isUrl("www.google.com"),                                    '!isUrl("www.google.com")');
ok(!isUrl(1),                                                   '!isUrl(1)');

is(isUser("hadoop"),    "hadoop",   'isUser("hadoop")');
is(isUser("hari1983"),  "hari1983", 'isUser("hari1983")');
ok(!isUser("-hari"),                '!isUser("-hari")');
ok(!isUser("1983hari"),             '!isUser("1983hari")');

ok(isOS($^O),    'isOS($^O)');

ok(HariSekhonUtils::loginit(),   'HariSekhonUtils::loginit()');
ok(HariSekhonUtils::loginit(),   'HariSekhonUtils::loginit() again since it should be initialized by first one');
ok(&HariSekhonUtils::log("hari testing"), '&HariSekhonUtils::log("hari testing")');

# TODO
# logdie

is(lstrip(" \t \n ha ri \t \n"),     "ha ri \t \n",   'lstrip()');
is(ltrim(" \t \n ha ri \t \n"),      "ha ri \t \n",   'ltrim()');

ok(msg_perf_thresholds(),   "msg_perf_thresholds()");

# TODO
#ok(HariSekhonUtils::msg_thresholds(),        "msg_thresholds()");

ok(open_file("/etc/hosts",1),           'open_file("/etc/hosts",1)');
ok(open_file("/etc/hosts",1,">>"),      'open_file("/etc/hosts",1,">>")');

ok(!pkill("nonexistentprogram"),         '!pkill("nonexistentprogram")');

is(plural(1),                       "",     'plural(1)');
is(plural(2),                       "s",    'plural(2)');
# code_error's out
#is(plural("string"),                "",     'plural("string")');
is(plural([qw/one/]),               "",     'plural(qw/one/)');
is(plural([qw/one two three/]),     "s",    'plural(qw/one two three/)');

# TODO
#ok(HariSekhonUtils::print_options(),       'print_options()');

# TODO
# quit

is(resolve_ip("a.resolvers.level3.net"),    "4.2.2.1",      'resolve_ip("a.resolvers.level3.net") returns 4.2.2.1');
is(resolve_ip("4.2.2.2"),                   "4.2.2.2",             'resolve_ip("4.2.2.2") returns 4.2.2.2');

is(rstrip(" \t \n ha ri \t \n"),     " \t \n ha ri",   'rstrip()');
is(rtrim(" \t \n ha ri \t \n"),      " \t \n ha ri",   'rtrim()');

is(set_sudo("hadoop"),      "echo | sudo -S -u hadoop ",    'set_sudo("hadoop")');
is(set_sudo(getpwuid($>)),  "",                             'set_sudo(getpwuid($>))');

# This is because the previous timer remaining time was 0
is(set_timeout(10),     0,      "set_timeout(10) eq 0");
is(set_timeout(10),     10,     "set_timeout(10) eq 10");

is(strip(" \t \n ha ri \t \n"),     "ha ri",   'strip()');
is(trim(" \t \n ha ri \t \n"),      "ha ri",   'trim()');

# TODO:
#ok(subtrace("test"), 'subtrace("test")');

done_testing();
