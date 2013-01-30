#!/bin/bash

clear
echo "First we'll take a look at an example."
read
vim  demo/example.pl
echo "We'll run that as it is and take a look at the \$config output."
read
echo -e "\033[32m"
perl -Ilib demo/example.pl
echo -e "\033[0m"
read
clear
echo "We see that we got the same structure we gave default.  Now we'll drop the file example_config.yaml in with the following contents:"
echo -e "\033[32m"
cat demo/config_example
echo -e "\033[0m"
read
mv demo/config_example demo/config_example.yaml
clear
echo "Now that the config file is in place, let's run it again."
echo -e "\033[32m"
perl -Ilib demo/example.pl
echo -e "\033[0m"
read
clear
echo "As we see, env has been overwritten by the file, and a new key secret_key was added by the config file."
read
echo "Now, let's use the command line argument --env staging to override both the default data structure and the file we loaded."
echo "perl -Ilib demo/example.pl --env staging"
read
echo -e "\033[32m"
perl -Ilib demo/example.pl --env staging
echo -e "\033[0m"
read
clear
echo "Environment variables can also be used to change the data structure in the same way"
echo "CONFIG_ENV=staging perl -Ilib demo/example.pl"
read
echo -e "\033[32m"
CONFIG_ENV=staging perl -Ilib demo/example.pl
echo -e "\033[0m"
read
clear
echo "One more cool thing... Template::ExpandHash is used, so the following will work:"
echo "perl -Ilib demo/example.pl --email \"[% user %]@other_domain.com"
read
echo -e "\033[32m"
perl -Ilib demo/example.pl --email "[% user %]@other_domain.com"
echo -e "\033[0m"



# Clean up.
mv demo/config_example.yaml demo/config_example
