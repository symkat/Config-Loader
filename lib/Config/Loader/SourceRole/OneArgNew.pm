package Config::Loader::SourceRole::OneArgNew;

use Moo::Role;

requires 'one_arg_name';

around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    if (@_ == 1 and (ref($_[0])||'') ne 'HASH') {
        return { $class->one_arg_name => $_[0] };
    }
    return $class->$orig(@_);
};

1;
