package Config::Loader::Source::Test;
use warnings;
use strict;
use base 'Config::Loader::Source';

sub load_config {
    return { "self" => shift, package => __PACKAGE__, valid => 1 };
}

1;
