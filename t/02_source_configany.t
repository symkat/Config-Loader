#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader qw( ConfigAny );

use Data::Dumper;


my $tests = [
    {
        name => "ConfigAny Loads File",
        line => __LINE__,
        put => { 
            file => "t/etc/config",
        },
        get => {
            foo => "bar",
            blee => "baz",
            bar => [ "this", "that" ],
        },
    },
    {
        name => "ConfigAny without file returns {}",
        line => __LINE__,
        put => { },
        get => { },
    },
    {
        name => "ConfigAny with invalid file returns {}",
        line => __LINE__,
        put => { file => "/invalid/path" },
        get => { },
    },
];

for my $test ( @{ $tests } ) {
    is_deeply( get_config( %{ $test->{put} } ), $test->{get},$test->{name}.' from line '.$test->{line} );
}

done_testing;
