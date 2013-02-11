#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader qw( Getopts );


my $tests = [
    {
        title   => "Default",
        line    => __LINE__,
        argv    => [qw()],
        put     => { 
            default => { 
            
            }, 
            source => "Getopts",
        },
        get => {
        
        },
    },
    {
        title   => "Remaining Keys",
        line    => __LINE__,
        argv    => [qw( foo bar )],
        put     => { 
            default => { 
            
            }, 
            source => "Getopts",
        },
        get => {
            argv => [ qw( foo bar ) ]
        },
    },
    {
        title   => "Renamed Remaining Keys",
        line    => __LINE__,
        argv    => [qw( foo bar )],
        put     => { 
            default => { 
            
            }, 
            getopts_argv_key    => "argv_left",
            source => "Getopts",
        },
        get => {
            argv_left   => [qw( foo bar )],
        },
    },
    {
        title   => "Remaining Keys Disregarded",
        line    => __LINE__,
        argv    => [qw( foo bar )],
        put     => { 
            default => { 
            
            }, 
            getopts_argv_key    => undef,
            source => "Getopts",
        },
        get => {
        
        },
    },
    {
        title   => "Spec Runs",
        line    => __LINE__,
        argv    => [qw( -i foo bar )],
        put     => { 
            default => { 
            
            }, 
            source => "Getopts",
            getopts_config => [ qw( i ) ]
        },
        get => {
            i           => 1,
            argv        => [qw( foo bar )]

        },
    },
    {
        title   => "Runs Spec - Subkeyed Return",
        line    => __LINE__,
        argv    => [qw( -i foo bar )],
        put     => { 
            default => { 
            
            }, 
            source => "Getopts",
            getopts_hash_key    => "subkey",
            getopts_config      => [qw( i )],
        },
        get => {
            subkey      => { i => 1 },
            argv        => [qw( foo bar )],
        },
    },
    {
        title   => "Runs Spec - All Keyed",
        line    => __LINE__,
        argv    => [qw( -i foo bar)],
        put     => { 
            default => { 
            
            }, 
            source => "Getopts",
            getopts_config => [qw( i )],
            getopts_hash_key    => "subkey",
            getopts_argv_key    => "magic",
        },
        get => {
            subkey      => { i => 1 },
            magic       => [qw( foo bar )],
        },
    },
    {
        title   => "Generated Specification - Hashes",
        line    => __LINE__,
        argv    => [qw( --foo a=1 --foo b=2 )],
        put     => { 
            default => { 
                foo     => {},
            }, 
            source => "Getopts",
        },
        get => {
            foo => { a => 1, b => 2 },
        },
    },
    {
        title   => "Generated Specification - Arrays",
        line    => __LINE__,
        argv    => [qw( --bar this --bar that )],
        put     => { 
            default => { 
                bar     => [],
            }, 
            source => "Getopts",
        },
        get => {
            bar => [qw( this that ) ],
        },
    },
    {
        title   => "Generated Specification - Numbers",
        line    => __LINE__,
        argv    => [qw( -n 5 )],
        put     => { 
            default => { 
                n       => 2,

            }, 
            source => "Getopts",
        },
        get => {
            n   => 5,
        },
    },
    {
        title   => "Generated Specification - Bools",
        line    => __LINE__,
        argv    => [qw( -y --no-j )],
        put     => { 
            default => { 
                y       => 0,
                j       => 1,
            }, 
            source => "Getopts",
        },
        get => {
            y   => 1,
            j   => 0,
        },
    },
    {
        title   => "Generated Specification - Global",
        line    => __LINE__,
        argv    => [qw( --foo a=1 --foo b=2 -n 5 -y --no-j --bar this --bar that )],
        put     => { 
            default => { 
                foo     => {},
                bar     => [],
                n       => 2,
                y       => 0,
                j       => 1,
                

            }, 
            source => "Getopts",
        },
        get => {
            foo => { a => 1, b => 2 },
            bar => [qw( this that ) ],
            n   => 5,
            y   => 1,
            j   => 0,
        },
    },
    {
        title   => "Generated Specification - Global Remaining",
        line    => __LINE__,
        argv    => [qw( --foo a=1 --foo b=2 -n 5 -y --no-j --bar this --bar that this )],
        put     => { 
            default => { 
                foo     => {},
                bar     => [],
                n       => 2,
                y       => 0,
                j       => 1,
                

            }, 
            source => "Getopts",
        },
        get => {
            foo => { a => 1, b => 2 },
            bar => [qw( this that ) ],
            n   => 5,
            y   => 1,
            j   => 0,
            argv => [ qw( this ) ],
        },
    },

];

for my $test ( @{ $tests } ) {
    
    # ARGV Injection
    @ARGV = @{ $test->{argv} };
    
    # Functional
    is_deeply(
        get_config( $test->{put} ), 
        $test->{get}, 
        sprintf( "Line %d/F: %s", $test->{line}, $test->{title})
    );

    # OO
    is_deeply(
        Config::Loader->new_source( 'Getopts', $test->{put} )->load_config, 
        $test->{get}, 
        sprintf( "Line %d/OO: %s", $test->{line}, $test->{title})
    );
}

done_testing;
