#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader qw( ENV );


my $tests = [
    {
        title   => "Default",
        line    => __LINE__,
        env     => {  },
        put => { 
            env_search      => [qw()],
            env_prefix      => "",
            env_postfix     => "",
        },
        get => {
        
        },
        source => "ENV",
    },
    {
        title   => "Search with env_search",
        line    => __LINE__,
        env     => { CONFIG_FOO => "baz", CONFIG_BLEE => "foo" },
        put => { 
            env_search      => [qw( foo blee )],
        },
        get => {
            foo => "baz",
            blee => "foo",
        
        },
        source => "ENV",
    },
    {
        title   => "Postfix Changes",
        line    => __LINE__,
        env     => {  },
        env     => { FOO_THING => "random", BLEE_THING => "modnar" },
        put => { 
            env_search      => [qw( foo blee )],
            env_prefix      => undef,
            env_postfix     => "THING",
        },
        get => {
            foo  => "random",
            blee => "modnar",
        },
        source => "ENV",
    },
    {
        title   => "Prefix Changes",
        line    => __LINE__,
        env     => {  },
        env     => { THAT_FOO => "world", THAT_BLEE => "hello" },
        put => { 
            env_search      => [qw( foo blee)],
            env_prefix      => "THAT",
            env_postfix     => undef,
        },
        get => {
            foo  => "world",
            blee => "hello",
        },
        source => "ENV",
    },
    {
        title   => "Prefix + Postfix Changes",
        line    => __LINE__,
        env     => {  },
        env     => { THAT_FOO_THING => "hello", THAT_BLEE_THING => "world" },
        put => { 
            env_search      => [qw( foo blee )],
            env_prefix      => "THAT",
            env_postfix     => "THING",
        },
        get => {
            foo  => "hello",
            blee => "world",
        },
        source => "ENV",
    },

];

for my $test ( @{ $tests } ) {
    
    # ENV Injection
    $ENV{$_} = $test->{env}->{$_} for keys %{ $test->{env} };
    
    # Functional
    is_deeply(
        get_config( $test->{put} ), 
        $test->{get}, 
        sprintf( "Line %d/F: %s", $test->{line}, $test->{title})
    );

    # OO
    is_deeply(
        Config::Loader->new_source( 'ENV', $test->{put} )->load_config, 
        $test->{get}, 
        sprintf( "Line %d/OO: %s", $test->{line}, $test->{title})
    );
}

done_testing;
