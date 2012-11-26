package Config::Loader::Source::Getopts;
use warnings;
use strict;
use base 'Config::Loader::Source';
use Getopt::Long;
use Scalar::Util qw( looks_like_number );
use Devel::Dwarn;

sub load_config {
    my ( $self ) = @_;
    
    # We have two modes of operation.  In one, we just run
    # GetOptions with the configurtion data structure that
    # the user gives us.  In the other we analyise the
    # inital data structure, and create a configuration
    # based on that.

    return GetOptions( \{}, @{ $self->args->{GetOptions} } )
        if $self->args->{GetOptions};

    return {} unless ref $self->default; # No data structure to use.

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
   
    my %config;
    GetOptions( \%config, @want );
    return { %config };
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
