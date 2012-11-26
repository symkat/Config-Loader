#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader qw( Test );
use lib 't/lib';

ok __PACKAGE__->can( "get_config" ), "get_config exported.";

my $struct = get_config;

is $struct->{package}, 'Config::Loader::Source::Test', "Right package";
is $struct->{self}->isa( "Config::Loader::Source" ), 1, "Is base class";
is $struct->{valid}, 1, "Known value is returned.";

done_testing;
