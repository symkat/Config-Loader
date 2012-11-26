package Config::Loader::Source::ENV;
use warnings;
use strict;
use base 'Config::Loader::Source';

sub load_config {
    my ( $self ) = @_;

    my $ds = $self->default;
    my $env_key = $self->args->{env_key} || "CONFIG";

    # Construct list of keys to search.
    push my @keys, keys( %{ $self->default || {} } );

    push @keys, @{ $self->args->{env_keys} } 
        if $self->args->{env_keys};

    for my $key ( @keys ) {
        $ds->{$key} = $ENV{uc($env_key . "_$key")}
            if exists $ENV{uc($env_key . "_$key")};
    }

    return $ds;
}

1;
