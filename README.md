# Silverstripe docker container
Basic docker container for Silverstripe 4 with PHP 7. Does not include database;


## Goals
* Nothing but Docker installed on Developers machines
* No missing dependencies for Silverstripe development
* No configuration required by Developers


## What this isn't
* A security hardened environment to run a production site on.
* A "out the box" ready to-go Silverstripe install. You'll still need to run composer install etc 


## Fixing permissions
If you manage to break /var/www/* so www-data can't access, 
copy and paste the following into the container:
```bash
chgrp www-data /var/www/ && \
chgrp www-data -R /var/www/ && \
chmod g+rwxs -R /var/www/
```
