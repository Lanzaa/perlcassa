#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;

$|++;

use vars qw($test_host $test_keyspace);

# Load default connect values from helper script??
# and actually use them?
$test_host = 'localhost';
$test_keyspace = 'xx_testing';

plan tests => 3;

require_ok( 'perlcassa' );

my $dbh;

$dbh = new perlcassa(
    'hosts' => [$test_host],
    'keyspace' => $test_keyspace,
);

my $res;

TODO: {
    eval {
        $res = $dbh->column_family(
            keyspace => $test_keyspace,
            columnname => 'testcf',
            action => 'create',
        );
    };
    ok ($res, "Create column family testcf.");
}

TODO: {
    eval {
        $res = $dbh->column_family(
            keyspace => $test_keyspace,
            columnname => 'testcf',
            action => 'drop',
        );
    };
    ok($res, "Drop keyspace testcf.");
}

$dbh->finish();    





