#!/usr/bin/perl
use warnings;
use strict;
use Config::Loader;
use Data::Dumper;

my $config = get_config({
    file => "demo/config_example",
    default => {
        user    => "symkat",
        email   => "symkat\@symkat.com",
        host    => "localhost",
        port    => "8080",
        env     => "dev",
    }
});

print Dumper $config;
