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
    return [ [ 'File', {} ], [ 'ENV', {} ], [ 'Getopts', {} ] ];
}

sub _build_loader {
    my ($self) = @_;
    my @sources = (
        $self->_new_source([ 'Static', { config => $self->default } ]),
        (map $self->_new_source($_), @{$self->sources}),
    );
    my $merged = Config::Loader->new_source('Merged', {
        sources => \@sources
    });
    return $merged unless $self->process_template;
    return $self->_new_source([ 'Filter::ExpandHash', { source => $merged } ]);
}

sub _new_source {
    my ( $self, $config ) = @_;
    my ( $type, $args ) = do {
        if (ref($config) eq 'ARRAY') {
            @$config;
        } else {
            ($config, {});
        }
    };
    $args = { default => $self->default, %$args };
    return Config::Loader->new_source($type, $self->overrides->{$type}||$args);
}

1;
