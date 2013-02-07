use inc::Module::Install;
  
# Define metadata
name           'Config-Loader';
all_from       'lib/Config/Loader.pm';
license        'perl';

# uses Module::Install::Repository
auto_set_repository;

# Specific dependencies
requires        'Config::Any'   => '0';
requires        'Moo'           => '0';
requires        'YAML'          => '0';

test_requires  'Test::More'     => '0.42';

WriteAll;
