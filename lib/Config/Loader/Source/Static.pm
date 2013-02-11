package Config::Loader::Source::Static;

use Moo;

has config => (is => 'ro', required => 1);

sub load_config { shift->config }

1;
