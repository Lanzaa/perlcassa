#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;

use Data::Dumper;

$|++;

plan tests => 3;

use perlcassa;# qw{prepare_inline_cql3};

is(perlcassa::prepare_inline_cql3("SELECT ':hello' FROM '  \" this place';"),
    "SELECT ':hello' FROM '  \" this place';",
    "String literals.");

my $params_01 = {
    query => "stu'ff",
    keyspace => "ecapsyek",
    cf => "fam_col",
    where_q => "Wear Clause",
};
is(perlcassa::prepare_inline_cql3("SELECT :query FROM :keyspace.:cf WHERE :where_q;  ", $params_01),
    "SELECT 'stu''ff' FROM 'ecapsyek'.'fam_col' WHERE 'Wear Clause';  ",
    "Parameter binding.");

my $params_02 = {
    query => "yay",
};
is(perlcassa::prepare_inline_cql3("select :query from ':query';", $params_02),
    "select 'yay' from ':query';",
    "Parameter binding and string quoting mixed.");

TODO: {
    local $TODO = "Query Comments are not yet enabled.";
}

