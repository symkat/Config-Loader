#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader ( Test => "test_function" );
use lib 't/lib';

is __PACKAGE__->can( "get_config" ), undef, "get_config not exported.";
ok __PACKAGE__->can( "test_function" ), "test_function exported.";

my $struct = test_function;

is $struct->{package}, 'Config::Loader::Source::Test', "Right package";
is $struct->{self}->isa( "Config::Loader::Source" ), 1, "Is base class";
is $struct->{valid}, 1, "Known value is returned.";

done_testing;
