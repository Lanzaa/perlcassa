#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More; # tests => 3;

use Data::Dumper;

$|++;

use vars qw($test_host $test_keyspace);

# Load default connect values from helper script??
# and actually use them?
$test_host = 'localhost';
$test_keyspace = 'xx_testing';

my $test_cf = 't_users';

plan tests => 3;

require_ok( 'perlcassa' );

my $dbh = new perlcassa(
    'hosts' => [$test_host],
    'keyspace' => $test_keyspace,
    #'columnfamily' => 'jj',#$test_cf,
);

my $res;

TODO: {
    eval {
        $res = $dbh->insert(
            key => 'key11',
            value => 'val11',
            columnname => 'col01',
        'columnfamily' => $test_cf,
        );
    };
    cmp_ok($res, 'eq', '', "Insert Key/Value.");
    print "res: ".Dumper($res);
    print "err: ".Dumper($@) if ($@);
}

TODO: {
    $res = $dbh->get(
        'key' => 'key11',
        'columnname' => 'col01',
        'columnfamily' => $test_cf,
    );
    cmp_ok($res, 'eq', 'val11', "Get simple value.");

    print "res: ".Dumper($res);
    print "err: ".Dumper($@) if ($@);
}

# TODO drop table and keyspace when done with testing
#$res = $dbh->column_family(
#    keyspace => $test_keyspace,
#    columnname => $test_cf,
#    action => 'drop',
#);

$dbh->finish();





