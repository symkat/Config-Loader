package Config::Loader::Source::Profile::Default;

use Config::Loader ();
use Module::Runtime qw(use_module);
use Moo;

has process_template   => (is => 'ro', default => sub { 1 } );
has sources => (
    is => 'ro', default => sub { shift->_default_sources },
);
has overrides => (is => 'ro', default => sub { {} });
has default => (is => 'ro', default => sub { {} });
has loader => (is => 'lazy', handles => [ 'load_config' ]);

sub BUILD {
    my ($self, $args) = @_;
    my @over_keys = grep /^[A-Z]/, keys %$args;
    @{$self->overrides}{@over_keys} = @{$args}{@over_keys};
}

sub _default_sources {
    return [ [ 'File', undef ], [ 'ENV', {} ], [ 'Getopts', {} ] ];
}

sub _build_loader {
    my ($self) = @_;
    my $merged = Config::Loader->new_source('Merged', {
        sources => [ map $self->_apply_overrides($_), @{$self->sources} ],
        default => $self->default,
    });
    return $merged unless $self->process_template;
    return Config::Loader->new_source(
      'Filter::ExpandHash', { source => $merged }
    );
}

sub _apply_overrides {
    my ( $self, $config ) = @_;
    my ( $type, $args ) = do {
        if (ref($config) eq 'ARRAY') {
            @$config;
        } else {
            ($config, {});
        }
    };
    # skip unconfigured sources
    return () unless $args or exists $self->overrides->{$type};
    return [ $type, $self->overrides->{$type}||$args ];
}

1;
