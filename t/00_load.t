#!/usr/bin/perl
use warnings;
use strict;
use Test::More;

use_ok $_ for ( 
    qw(
        Config::Any
        Getopt::Long
        Template::ExpandHash
        
        Config::Loader
        Config::Loader::Source
        Config::Loader::Source::ENV
        Config::Loader::Source::ConfigAny
        Config::Loader::Source::Getopts
        Config::Loader::Source::Layered
    )
);

done_testing;
