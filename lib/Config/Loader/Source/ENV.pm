package Config::Loader::Source::ENV;
use Moo;

extends 'Config::Loader::Source';

has env_prefix   => ( is => 'ro', default => sub { "CONFIG" } );
has env_postfix  => ( is => 'ro', default => sub { "" } );
has env_search   => ( is => 'ro', default => sub { [  ] } );

sub load_config {
    my ( $self ) = @_;

    my $ds = $self->default;

    # Construct list of keys to search.
    push my @keys, 
        ( keys( %{ $self->default || {} }  ), 
        @{ $self->env_search } );

    for my $key ( @keys ) {
        my $search = 
            ( $self->env_prefix 
                ? $self->env_prefix . "_"
                : ""
            ) 
            .
            uc( $key )
            .
            ( $self->env_postfix
                ? "_" . $self->env_postfix
                : ""
            )
        ;

        $ds->{$key} = $ENV{$search} if exists $ENV{$search};
    }

    return $ds;
}

1;
