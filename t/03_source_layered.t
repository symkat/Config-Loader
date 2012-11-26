#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader;

use Data::Dumper;


my $tests = [
    {
        name => "ConfigAny Loads File",
        put => { 
            file => "/dev/null",
            sources => [ 'ConfigAny', { file => "t/etc/config" } ],
        },
        get => {
            foo => "bar",
            blee => "baz",
            bar => [ "this", "that" ],
        },
    },
    {
        name => "ConfigAny without file returns {}",
        put => { },
        get => { },
    },
    {
        name => "ConfigAny with invalid file returns {}",
        put => { file => "/invalid/path" },
        get => { },
    },
];

for my $test ( @{ $tests } ) {
    is_deeply( get_config( %{ $test->{put} } ), $test->{get}); # $test->{name};
}

done_testing;
