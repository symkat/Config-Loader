package Config::Loader::Source::Merged;

use Config::Loader ();
use Hash::Merge::Simple qw(merge);
use Moo;

has default => (is => 'ro', default => sub { {} });

has sources => (is => 'ro', required => 1);

has source_objects => (is => 'lazy', builder => sub {
  my ($self) = @_;
  my $default = $self->default;
  [
    Config::Loader->new_source('Static', config => $default),
    map Config::Loader->new_source(
      $_->[0], { default => $default, %{$_->[1]} }
    ), @{$self->sources}
  ]
});

sub load_config {
    my ( $self ) = @_;
    return merge map $_->load_config, @{$self->source_objects};
}

1;
