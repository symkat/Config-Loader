package Config::Loader::Source;
use Moo;

# Sources must use strict and warnings.  =)
sub import {
    strict->import();
    warnings->import();
}

sub BUILD {
    my ( $self, $args ) = @_;
    $self->_set_args( $args );
}

has args    => ( is => 'rwp' );
has default => ( is => 'rw', default => sub { return {} }  );

sub get_config {
    my ( $self, @args ) = @_;

    return $self->load_config( @args );
}

1;
