#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader;


my $tests = [
    {
        name => "",
        put => { 
            default => { 
            
            }, 
        },
        get => {
        
        },
    },

];

for my $test ( @{ $tests } ) {
    is_deeply get_config( %{ $test->{put} } ), $test->{get}, $test->{name};
}

done_testing;
