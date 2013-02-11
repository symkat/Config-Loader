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
        Config::Loader::Source::ENV
        Config::Loader::Source::File
        Config::Loader::Source::Getopts
        Config::Loader::Source::Merged
        Config::Loader::Source::Profile::Default
    )
);

done_testing;
