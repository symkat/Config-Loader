package Config::Loader::Source::Test;

use Moo;

sub load_config {
    return { "self" => shift, package => __PACKAGE__, valid => 1 };
}

1;
