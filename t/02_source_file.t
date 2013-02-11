#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader qw( File );

use Data::Dumper;


my $tests = [
    {
        name => "File Loads File",
        line => __LINE__,
        put => { 
            stem => "t/etc/config",
        },
        get => {
            foo => "bar",
            blee => "baz",
            bar => [ "this", "that" ],
        },
    },
    {
        name => "File without file returns {}",
        line => __LINE__,
        put => { },
        get => { },
    },
    {
        name => "File with invalid file returns {}",
        line => __LINE__,
        put => { stem => "/invalid/path" },
        get => { },
    },
];

for my $test ( @{ $tests } ) {
    # Functional
    is_deeply( get_config( %{ $test->{put} } ), $test->{get},$test->{name}.' from line '.$test->{line} );
    # OO
    is_deeply( 
        Config::Loader->new_source( 'File', %{ $test->{put} }  )->load_config,
        $test->{get},
        $test->{name}.' from line '.$test->{line} 
    );
}

done_testing;
