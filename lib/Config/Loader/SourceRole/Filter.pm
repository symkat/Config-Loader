package Config::Loader::SourceRole::Filter;

use Moo::Role;

requires 'filter_config';

has source => (is => 'ro', required => 1);

sub load_config {
  my ($self) = @_;
  return $self->filter_config($self->source->load_config);
}

1;
