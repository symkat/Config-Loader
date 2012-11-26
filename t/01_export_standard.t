#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader;
use lib 't/lib';
use Data::Dumper;


ok __PACKAGE__->can( "get_config" ), "Function exported.";

is_deeply get_config( default => {}), {}, "Layered ran.";

done_testing;
