use inc::Module::Install;
  
# Define metadata
name           'Config-Loader';
all_from       'lib/Config/Loader.pm';
license        'perl';

# uses Module::Install::Repository
auto_set_repository;

# General Core Requirements
requires        'Moo'                   => '0';

# Loaders, Filters, etc
requires        'Config::Any'           => '0';
requires        'YAML'                  => '0';
requires        'Template::ExpandHash'  => '0';

# For Tests
test_requires  'Test::More'     => '0.42';

WriteAll;
