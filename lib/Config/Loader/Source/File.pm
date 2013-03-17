package Config::Loader::Source::File;

use Config::Any;
use File::Spec;
use Moo;

with 'Config::Loader::SourceRole::OneArgNew';

sub one_arg_name { 'file' }

has file => (is => 'ro', required => 1);
has load_args => (is => 'ro', default => sub { {} });

has load_type => (is => 'lazy', builder => sub {
  (File::Spec->splitpath($_[0]->file))[2] =~ /\./ ? 'files' : 'stems'
});

sub load_config {
  my ($self) = @_;
  my $config = (values %{$self->_load_config_any->[0]||{}})[0];
  return $config || {};
}

sub _load_config_any {
  my ($self) = @_;
  Config::Any->${\"load_${\$self->load_type}"}({
    $self->load_type => [ $self->file ],
    use_ext => (not exists $self->load_args->{force_plugins}),
    %{$self->load_args},
  });
}

1;
