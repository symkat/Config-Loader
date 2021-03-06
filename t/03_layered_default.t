#!/usr/bin/perl
use warnings;
use strict;
use Config::Loader;
use Test::More;

my $tests = [
    {
        put => { verbose => 1, run => 0, },
        argv => [ qw( ) ],
        get => { verbose => 1, run => 0, },
        title => "Flags - Change Neither",
        line  => __LINE__,
    },
    {
        put => { verbose => 1, run => 0, },
        argv => [ qw( --run --noverbose ) ],
        get => { verbose => 0, run => 1, },
        title => "Flags - Change Both",
        line  => __LINE__,
    },
    {
        put => { verbose => 1, run => 0, },
        argv => [ qw( --noverbose ) ],
        get => { verbose => 0, run => 0, },
        title => "Flags - Change One",
        line  => __LINE__,
    },
    {
        put => { verbose => 1, run => 0, },
        argv => [ qw( --norun --verbose ) ],
        get => { verbose => 1, run => 0, },
        title => "Flags - Same Set",
        line  => __LINE__,
    },
    {
        put => { verbose => "yes", run => "no", },
        argv => [ qw() ],
        get => { verbose => "yes", run => "no", },
        title => "Strings -- Change Neither",
        line  => __LINE__,
    },
    {
        put => { verbose => "yes", run => "no", },
        argv => [ qw( --verbose no ) ],
        get => { verbose => "no", run => "no", },
        title => "Strings -- Change One",
        line  => __LINE__,
    },
    {
        put => { verbose => "yes", run => "no", },
        argv => [ qw( --verbose no --run yes ) ],
        get => { verbose => "no", run => "yes", },
        title => "Strings -- Change Both",
        line  => __LINE__,
    },
    {
        put => { verbose => "yes", run => "no", },
        argv => [ qw( --verbose yes --run no) ],
        get => { verbose => "yes", run => "no", },
        title => "Strings -- Same Set",
        line  => __LINE__,
    },
    {
        put => { verbose => 1, run => "yes", },
        argv => [ qw() ],
        get => { verbose => 1, run => "yes", },
        title => "Flags + Strings -- Change Neither",
        line  => __LINE__,
    },
    {
        put => { verbose => 0, run => "yes", },
        argv => [ qw( --verbose --run no) ],
        get => { verbose => 1, run => "no", },
        title => "Flags + Strings -- Change Both",
        line  => __LINE__,
    },
    {
        put => { verbose => 1, run => "yes", },
        argv => [ qw( --run no ) ],
        get => { verbose => 1, run => "no", },
        title => "Flags + Strings -- Change One",
        line  => __LINE__,
    },
    {
        put => { verbose => 1, run => "yes", },
        argv => [ qw( --verbose --run yes) ],
        get => { verbose => 1, run => "yes", },
        title => "Flags + Strings -- Set Both",
        line  => __LINE__,
    },

    {
        put => { verbose => 1, run => 0, foo => [ qw( bar blee ) ] },
        argv => [ qw() ],
        get => { verbose => 1, run => 0, foo => [ qw( bar blee ) ] },
        title => "Flags + Strings + Array Ref -- Change Nothing",
        line  => __LINE__,
    },
    {
        put => { verbose => 1, run => 0, foo => [ qw( bar blee ) ] },
        argv => [ qw( --foo bar --foo blee --foo this ) ],
        get => { verbose => 1, run => 0, foo => [ qw( bar blee this ) ] },
        title => "Flags + Strings + Array Ref - Override Array",
        line  => __LINE__,
    },
    {
        put => { verbose => 1, run => 0, foo => [ qw( bar blee ) ] },
        argv => [ qw( --foo foo ) ],
        get => { verbose => 1, run => 0, foo => [ qw( foo ) ] },
        title => "Flags + Strings + Array Ref -- Override Array, Blanked",
        line  => __LINE__,
    },
    {
        put => { verbose => 1, run => 0, foo => [ qw( bar blee ) ] },
        argv => [ qw( --foo bar --foo blee ) ],
        get => { verbose => 1, run => 0, foo => [ qw( bar blee ) ] },
        title => "Flags + Strings + Array Ref -- Set ",
        line  => __LINE__,
    },
#    {
#        put => { verbose => 1, run => 0, foo => [ qw( bar blee ) ], blee => { foo => 1 } },
#        argv => [ qw() ],
#        get => { verbose => 1, run => 0, foo => [ qw( bar blee ) ], blee => { foo => 1 } },
#        title => "Flags + Strings + Array Ref + Hashref -- Nothing Changed",
#    },
#    {
#        put => { verbose => 1, run => 0, foo => [ qw( bar blee ) ], blee => { foo => 1 } },
#        argv => [ qw( --blee foo=5 ) ],
#        get => { verbose => 1, run => 0, foo => [ qw( bar blee ) ], blee => { foo => 5 } },
#        title => "Flags + Strings + Array Ref + Hashref -- Change Value",
#    },
#    {
#        put => { verbose => 1, run => 0, foo => [ qw( bar blee ) ], blee => { foo => 1 } },
#        argv => [ qw( --blee bar=1) ],
#        get => { verbose => 1, run => 0, foo => [ qw( bar blee ) ], blee => { foo => 1, bar => 1 } },
#        title => "Flags + Strings + Array Ref + Hashref -- Add To Hashref",
#    },
];

for my $test ( @$tests ) {
    # Change ENV Vars...
    for my $key ( keys %{$test->{put}} ) {
        $ENV{ "CONFIG_" . uc($key)} = $test->{put}->{$key};
    }

    # Change ARGV
    @ARGV = @{ $test->{argv} };

    # This test will set the defaults for ENV... and expect them to
    # be filled fro $ENV.
    
    # OO
    is_deeply( 
        Config::Loader->new_source( 
            'Layered',
            {
                default => { map { $_ => "" } keys %{$test->{put}} }, 
                sources => [ 'ENV', 'Getopts' ],
                getopts_hash_key => undef,
            }
        )->get_config,
        $test->{get},
        sprintf( "Line %d/OO: %s", $test->{line}, $test->{title} ),
    );
    
    # Change ARGV again ( destructive change )
#    @ARGV = @{ $test->{argv} };

    # Functional
    is_deeply( 
        get_config(
            default => { map { $_ => "" } keys %{$test->{put}} }, 
            sources => [ 'ENV', 'Getopts' ],
            getopts_hash_key => undef,
        ), 
        $test->{get}, 
        sprintf( "Line %d/F: %s", $test->{line}, $test->{title} ),
    );
    
}

done_testing;
