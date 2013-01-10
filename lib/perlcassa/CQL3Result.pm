package perlcassa::CQL3Result;

use strict;
use warnings;
#use base 'Exporter';

# TODO export stuff?
#our @EXPORT = qw(setup close_conn client_setup fail_host);

use perlcassa::Decoder qw{make_cql3_decoder};

use Cassandra::Cassandra;
use Cassandra::Constants;
use Cassandra::Types;

use Data::Dumper;

sub new {
    my ($class, %opt) = @_;
    # TODO ... i dont know perl btw
    bless my $self = {
        idx => 0,
        result => undef, 
        type => undef,
        rowcount => undef,
        debug => 0, # TODO allow this to be set
    }, $class;
}

##
# Process the Casssandra::CqlResult from a CQL3 call.
#
# This expects the full CqlResult and returns 1 on error, 0 on success. Or it
# Returns:
#   0 on success.
#   1 on error.
#   dies on unrecoverable error. (Please file a bug report)
#
##
sub process_cql3_results {
    my ($self, $response) = @_;
    my $ret = 1;
    if ($self->{debug}) {
        $self->{response} = $response;
    }

    $self->{type} = $response->{type};
    if ($self->{type} == Cassandra::CqlResultType::ROWS) {
        # TODO
        #die("[ERROR] Not implemented CqlResultType::ROWS.");

        #TODO parse the schema
        # $response->{schema}
        # py cql parses the schema to get a decoder stored
        my $decoder = make_cql3_decoder($response->{schema});

        # populate the decoder with data from the first result row
        # it should have all of the columns
        $self->{result} = [];
        $self->{rowcount} = $#{$response->{rows}};
        foreach my $row (@{$response->{rows}}) {
            my %unpacked_row = $decoder->decode_row($row);
            push($self->{result}, \%unpacked_row);
        }
        $ret = 0;
    } elsif ($self->{type} == Cassandra::CqlResultType::VOID) {
        # TODO # may be error may be success. check $@. Cassandra::InvalidRequestException
        $self->{rowcount} = 0;
        $ret = 0;
    } elsif ($self->{type} == Cassandra::CqlResultType::INT) {
        # TODO find out how to get this
        die("[ERROR] Not implemented CqlResultType::INT.");
    } else {
        die("[ERROR] Unknown CQL result type ($self->{type}).");
    }
    return $ret;
}

##
# TODO better documentation
#
# this is a simple call, returns a row of data
#
# if there is no more data it dies
#
# it should return a proper error value on out of data
##
sub fetchone {
    my $self = shift;
    if ($self->{idx} <= $self->{rowcount}) {
        return @{$self->{result}}[$self->{idx}++];
    }
    return undef;
    die("[ERROR] Out of rows to return.");
}

# callers need to specify count
sub fetchmany {
    my $self = shift;
    my $count = shift;
    die("[ERROR] Not implemented.");
}

# users will want this, but it may return a large number of rows.
sub fetchall {
    my $self = shift;
    die("[ERROR] Not implemented.");
}

1;
