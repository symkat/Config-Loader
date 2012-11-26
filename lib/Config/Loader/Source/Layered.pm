package Config::Loader::Source::Layered;
use warnings;
use strict;
use base 'Config::Loader::Source';
use Moo;
use Module::Runtime qw( use_module );
use Data::Dumper;
use Template::ExpandHash qw( expand_hash );
use Devel::Dwarn;
use Storable qw( dclone );

has normalized_sources => (is => 'lazy');
has process_template   => (is => 'ro', default => sub { 1 } );

sub load_config {
    my ( $self ) = @_;

    my $config = $self->default;

    for my $source ( @{ $self->normalized_sources } ) {
        my $pkg = $self->_load_source( $source->[0] )
            ->new( { %{ $self->_merge( $self->args, $source->[1] ) } } );

        $config = $self->_merge( $config, ( $pkg->get_config || {} ) );
    }

    return expand_hash( $config ) if $self->process_template;
    return $config;
}

sub _load_source {
    my ( $self, $package ) = @_;

    if ( substr( $package, 0, 1 ) eq '+' ) {
        return use_module( substr( $package, 1 ) );
    } else {
        return use_module( "Config::Loader::Source::$package" );
    }
}

sub _merge {
    my ( $self, $content, $data ) = @_;

    # Allow this method to be replaced by a coderef.
    # TODO: Make this work again.
    # return $self->merge->( $content, $data ) if ref $self->merge eq 'CODE';

    if ( ref $content eq 'HASH' ) {
        for my $key ( keys %$content ) {
            if ( ref $content->{$key} eq 'HASH' ) {
                $content->{$key} = $self->_merge($content->{$key}, $data->{$key});
                delete $data->{$key};
            } else {
                $content->{$key} = delete $data->{$key} if exists $data->{$key};
            }
        }
        # Unhandled keys (simply do injection on uneven rhs structure)
        for my $key ( keys %$data ) {
            $content->{$key} = delete $data->{$key};
        }
    }

    return $content;
}

sub _build_normalized_sources {
    my ( $self ) = @_;

    return [ [ 'ConfigAny', {} ], [ 'Getopts', {} ], [ 'ENV', {} ] ]
        unless $self->args->{sources};

    my @sources = @{ $self->{args}->{sources} };
    my @new_sources;

    while ( my $source = shift @sources ) {
        push @new_sources, [ $source, ref $sources[0] eq 'HASH' ? shift @sources : {  } ];
    }

    return \@new_sources;
}

1;
