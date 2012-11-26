package Config::Loader;
use warnings;
use strict;

sub import {
    my ( $class, $source, $export ) = @_;
    $source ||= "Layered";
    $export ||= "get_config";

    my $target = caller . "::" . $export;
    
    no strict 'refs';
    *$target = sub {
        eval "require Config::Loader::Source::$source";
        if ( $@ ) {
            die "Error loading Config::Loader::Source::$source: $@";
        }
        return "Config::Loader::Source::$source"->new(@_)->get_config;
    };
}

1;

=head1 NAME

Config::Loader - The Universal Configuration Loader

=head1 DESCRIPTION

Config.::Loader provides a consistent interface to loading configuration
data from files, command line input, environment variables and anything
else you'd like to load configuration from.

This document will describe the way Config::Loader works by default.

Other Documentation

=over4

=item * L<Config::Loader::Cookbook::Introduction> - Detailed information 
on how Config::Loader works.

=item * L<Config::Loader::Cookbook::Sources> - How to make Config::Loader 
work with your favorite method of loading configuration data.

=back 

=head1 SYNOPSIS

    #!/usr/bin/perl
    use warnings;
    use strict;
    use Config::Loader;

    my $config = get_config({
        file => "/etc/my_app",
        default => {
            host        => "localhost",
            port        => 8080,
            name        => "My Application",
        },
    });

    printf("Configured %s on http://%s:%s/", 
        $config->{name}, $config->{host}, $config->{port}
    );


=head1 METHODS

=head2 get_config()

This is the only method exported by Config::Loader.  By default it uses four sources
for configuration data.  Each source of data can be added to and overwritten by each
successive source of configuration data.

=head3 default

The default data structure is defined when initially making the call the get_config().

    my $config = get_config({
        default => {
            some_key            => "some string",
            some_other_key      => [qw( some array elements )]
            a_hash_ref          => { key => "value" },
        }.
    });

This structure is the initial configuration, further some sources use this information
in making decisions on configuration, such as Getopts, and ENV as we will see later.

=head3 ConfigAny

The next source of configuration data that is looked at is a configuration file loaded
by L<Config::Any>.  To specify a file to check for configuration data use the accessor
B<file> in your call.

    my $config = get_config({
        file => "/etc/my_app",
        default => {
            some_key            => "some string",
            some_other_key      => [qw( some array elements )]
            a_hash_ref          => { key => "value" },
        }.
    });

Now the file B</etc/my_app.*> will be checked, you must use a file extension that
L<Config::Any> recognizes.  If any of some_key, some_other_key or a_hash_ref are
defined in the configuration file, they will overwrite the values in the default data
structure.

Any new keys given by GetOpts will be added to the data structure. 

=head3 GetOpts

The next source looked at will be GetOpts.  By default, any top-level key that exists in 
the default data structure will be checked for its type (string, array, hash ref, boolean)
and used for the configuration for a call to GetOptions.

You can specific your own instruction set for the GetOptions call by adding the accessor
GetOptions and passing an array reference for values to check.  Keep in mind this will
B<not> add to the structure checked by the default data structure, but completely substitute
it.

    my $config = get_config({
        file => "/etc/my_app",
        default => {
            some_key            => "some string",
            some_other_key      => [qw( some array elements )]
            a_hash_ref          => { key => "value" },
        },
        GetOptions => [qw( some_key=s some_other_key=@ a_hash_ref=% email=s )]
    });

This will mimic the structure that would have been created by the default data structure,
but adds the string email as well.

If any key which is already defined is returned by GetOptions it will overwrite the data 
structure as it is to this point.

Any new keys given by GetOpts will be added to the data structure. 

=head3 ENV

The next source looked at it ENV.  This source will check the default data structure and
check for CONFIG_$key_name in the environment variables, is found it will replace it
in the configuration.  


    my $config = get_config({
        file => "/etc/my_app",
        default => {
            some_key            => "some string",
            some_other_key      => [qw( some array elements )]
            a_hash_ref          => { key => "value" },
        },
        GetOptions => [qw( some_key=s some_other_key=@ a_hash_ref=% email=s )]
    });

If you run the script with C<CONFIG_SOME_KEY=foo ./script> some_key's value will be replaced
with the value C<foo>.  No values which are not a top-level key in the data structure will be checked.

=head1 AUTHOR

=over4

Kaitlyn Parkhurst (SymKat) I<E<lt>symkat@symkat.comE<gt>> ( Blog: L<http://symkat.com/> )

=back

=head1 CONTRIBUTORS

=over4

=item * Matt S. Trout (mst) I<E<lt>mst@shadowcat.co.ukE<gt>>

=back

=head1 SPONSORS

=head1 COPYRIGHT

Copyright (c) 2012 the Config::Loader L</AUTHOR>, L</CONTRIBUTORS>, and 
L</SPONSORS> as listed above.

=head1 LICENSE

=head1 AVAILABILITY

1;


