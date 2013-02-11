package Config::Loader::Source::Getopts;
use Moo;
use Getopt::Long qw( GetOptionsFromArray );
use Scalar::Util qw( looks_like_number );

has getopts_argv_key => ( is => 'rw', default => sub { "argv" } );
has getopts_hash_key => ( is => 'rw' );
has getopts_config   => ( is => 'ro' );
has default          => ( is => 'ro' );
has config           => ( is => 'lazy');

sub load_config {
    my ( $self ) = @_;
    
    return {} unless $self->config;

    my @copy = @ARGV;
    
    GetOptionsFromArray( \@copy, \my %config, @{ $self->config } );

    my %final = ( 
        $self->getopts_hash_key 
            ? ( $self->getopts_hash_key => { %config } )
            : %config
    );
    
    if ( @copy and my $key = $self->getopts_argv_key ) { 
        $final{$key} = \@copy; 
    }

    return { %final };
}

sub _build_config {
    my ( $self ) = @_;

    return $self->getopts_config if $self->getopts_config;
    return undef unless $self->default;
    
    my @want;

    for my $key ( keys %{ $self->default } ) {
        if ( ref $self->default->{$key} eq 'ARRAY' ) {
            push @want, "$key=s@";
        } elsif ( ref $self->default->{$key} eq 'HASH' ) {
            push @want, "$key=s%";
        } elsif ( $self->_is_bool($self->default->{$key}) ) {
            push @want, "$key!";
        } else {
            push @want, "$key=s";
        }
    }
    
    return [ @want ];
}

# TODO: Boolean detection has a bug in it.  If we use
# the default data structure, and a value is 1 we will
# mark is as a boolean.  We need an unobtrusive way
# of saying 1 is a boolean or not a boolean.  If we
# mark is as a string, --no$key will not work.  If we
# mark is as a boolean --$key 5 will not work.
#
# TODO : Idea: Merge the data parsing and the default
# together.  
#
# get_config( 
#     default => { foo => 1 }, 
#     GetOptions( qw( "foo=s" ) ) 
# );

sub _is_bool {
    my ( $self, $value ) = @_;

    return 0 unless looks_like_number( $value );
    return 1 if $value == 0;
    return 1 if $value == 1;
    return 0;
}

1;
