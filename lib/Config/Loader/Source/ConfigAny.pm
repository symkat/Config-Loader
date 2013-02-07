package Config::Loader::Source::ConfigAny;
use Moo;
extends 'Config::Loader::Source';
use Config::Any;

has file   => ( is => 'ro' );
has stem   => ( is => 'ro' );
has files  => ( is => 'ro', isa => sub { ref $_[0] eq 'ARRAY' });
has stems  => ( is => 'ro', isa => sub { ref $_[0] eq 'ARRAY' });


has config_any_filter => ( 
    is => 'ro', 
    isa => sub { ref $_[0] eq 'CODE' },
    default => sub { sub { return $_[0] } },
);
has config_any_use_ext => ( 
    is => 'ro', 
    default => sub { 1 } 
);
has config_any_driver_args => ( 
    is => 'ro',  
    isa => sub { ref $_[0] eq 'HASH' },
    default => sub { { } },
);

has layered_sources => ( is => 'lazy' );
has layered_args    => ( is => 'lazy' );
has has_files       => ( is => 'lazy' );

sub load_config {
    my ( $self ) = @_;
    

    # Supports:
    #
    #   file  - Handled here
    #   stem  - Handled here
    #   files - Dispatch through Config::Loader::Source::Layered
    #   stems - "
    #   config_any_{option}

    return {} unless $self->has_files;

    # When someone doesn't use a single stem or file,
    # we go into DWIM mode and call on the power of 
    # C:L:S::Layered to sort it out.  The merge order
    # is the following:
    #  1)  Stems, in the order given
    #  2)  Files, in the order given
    #  3)  Stem
    #  4)  File

    if ( $self->do_what_i_mean ) {
        return Config::Loader->new_source(
            'Layered',
            {
                %{ $self->layered_args },
                sources => $self->layered_sources,
            },
        )->load_config;
    }

    my $config;

    if ( $self->file ) {
        $config = Config::Any->load_files({
            files   => [ $self->file ],
            use_ext => $self->config_any_use_ext,
            filter  => $self->config_any_filter,
            driver_args => $self->config_any_driver_args,
        });

    } elsif ( $self->stem ) {
        $config = Config::Any->load_stems({
            stems   => [ $self->stem ],
            use_ext => $self->config_any_use_ext,
            filter  => $self->config_any_filter,
            driver_args => $self->config_any_driver_args,

        });
    }

    return $config->[0]->{ ( keys %{ $config->[0] } )[0] }
        if @{ $config } == 1;
    
    return {};
}

sub do_what_i_mean {
    my ( $self ) = @_;

    return 1 if $self->stem && $self->file;
    return 1 if $self->stems;
    return 1 if $self->files;
    return 0;
}

sub _build_has_files {
    my ( $self ) = @_;

    return 1 if $self->file;
    return 1 if $self->stem;
    return 1 if $self->files;
    return 1 if $self->stems;
    return 0;
}

sub _build_layered_sources {
    my ( $self ) = @_;
    
    my @sources;

    for my $stem ( @{ $self->stems || [] } ) {
        push @sources, ( "ConfigAny", { stem => $stem } );
    }
    
    for my $file ( @{ $self->files || [] } ) {
        push @sources, ( "ConfigAny", { file => $file } );
    }

    if ( $self->stem ) {
        push @sources, ( "ConfigAny", { stem => $self->stem } );
    }

    if ( $self->file ) {
        push @sources, ( "ConfigAny", { file => $self->file } );
    }

    return [ @sources ];

}

sub _build_layered_args {
    my ( $self ) = @_;

    return {
        config_any_use_ext     => $self->config_any_use_ext,
        config_any_filter      => $self->config_any_filter,
        config_any_driver_args => $self->config_any_driver_args,
    }
}

1;
