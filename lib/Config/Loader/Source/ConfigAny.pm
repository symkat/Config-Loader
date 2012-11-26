package Config::Loader::Source::ConfigAny;
use warnings;
use strict;
use base 'Config::Loader::Source';
use Config::Any;

sub load_config {
    my ( $self ) = @_;
    
    return {} unless $self->args->{file};

    my $config = Config::Any->load_stems({
        stems   => [ $self->args->{file} ],
        use_ext => 1,
    });

    return $config->[0]->{ ( keys %{ $config->[0] } )[0] }
        if @{ $config } == 1;
    
    return {};
}

1;
