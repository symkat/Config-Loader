#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use Config::Loader qw( );
use lib 't/lib';


is __PACKAGE__->can( "get_config" ), undef, "Not exported to namespace.";

done_testing;
