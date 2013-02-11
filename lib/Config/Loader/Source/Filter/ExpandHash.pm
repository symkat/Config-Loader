package Config::Loader::Source::Filter::ExpandHash;

use Moo;
use Template::ExpandHash qw(expand_hash);

with 'Config::Loader::SourceRole::Filter';

sub filter_config { expand_hash($_[1]) }

1;
