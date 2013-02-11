package Config::Loader::Source::Merged;

use Moo;
use Hash::Merge::Simple qw(merge);

has sources => (is => 'ro', required => 1);

sub load_config {
    my ( $self ) = @_;
    return merge map $_->load_config, @{$self->sources};
}

1;
