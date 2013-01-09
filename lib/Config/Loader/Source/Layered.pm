package Config::Loader::Source::Layered;
use Moo;
extends 'Config::Loader::Source';
use Template::ExpandHash qw( expand_hash );
use Storable qw( dclone );
use Devel::Dwarn;

has normalized_sources => (is => 'lazy');
has process_template   => (is => 'ro', default => sub { 1 } );
has sources => ( is => 'ro' );

sub load_config {
    my ( $self ) = @_;

    my $config = $self->default;

    # Some constructures pass code refs, to use dclone, we must
    # enable deparse and eval to handle this -- rest assured they're
    # put back to whatever values the user may have set elsewhere.
    my ( $deparse, $eval ) = ( $Storable::Deparse, $Storable::Eval );
    ( $Storable::Deparse, $Storable::Eval ) = ( 1, 1 );

    for my $source ( @{ $self->normalized_sources } ) {
        # You MUST dclone $self->args, as _merge is mutating,
        # you will end up pushing source-specific configuration
        # into subsequent calls, which is completely wrong.
        my $obj = Config::Loader->new_source(
            $source->[0],
            { %{ $self->_merge( dclone($self->args), $source->[1] ) } }
        );

        $config = $self->_merge( $config, ( $obj->get_config || {} ) );
    }

    ( $Storable::Deparse, $Storable::Eval ) = ( $deparse, $eval );

    return expand_hash( $config ) if $self->process_template;
    return $config;
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

        #my @sources = @{ $self->{args}->{sources} };
    my @sources = @{ $self->sources };
    my @new_sources;

    while ( my $source = shift @sources ) {
        push @new_sources, [ $source, ref $sources[0] eq 'HASH' ? shift @sources : {  } ];
    }

    return \@new_sources;
}

1;
