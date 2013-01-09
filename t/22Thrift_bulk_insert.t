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

plan tests => 4;

require_ok( 'perlcassa' );

my $dbh = new perlcassa(
    'hosts' => [$test_host],
    'keyspace' => $test_keyspace,
    'columnfamily' => $test_cf,
);

my $res;

TODO: {
    local $TODO = 'currently bulk_insert return undef on success.';

    my %bulk = (
        # columnname => [value]
        'val31' => ['test31'],
        'val32' => ['test32'],
    );
    is($dbh->bulk_insert(key => 'bulk_key99', columns => \%bulk),
        0,
        "bulk_insert values."
    );
}

is($dbh->get('key' => 'bulk_key99', 'columnname' => 'val31'),
    'test31',
    "Get first after bulk_insert."
);

is($dbh->get('key' => 'bulk_key99', 'columnname' => 'val32'),
    'test32',
    "Get last after bulk_insert."
);



# TODO drop table and keyspace when done with testing
#$res = $dbh->column_family(
#    keyspace => $test_keyspace,
#    columnname => $test_cf,
#    action => 'drop',
#);

$dbh->finish();





