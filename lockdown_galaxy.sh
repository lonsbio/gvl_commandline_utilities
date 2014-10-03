#/bin/sh

introduction="
Run this script as a sudo user to modifiy the Galaxy configuration to:
 1. Prevent new user creation
 2. Prevent OpenID being used to login
 3. Require a login to access Galaxy
 
You may need to restart Galaxy for the changes to take effect.

If you have not created any users (i.e an admin user, and have also added via Cloudman admin) yet for Galaxy, abort now.
" 

echo "$introduction" 
echo "Press enter to continue (or Ctrl-C to abort):"                                                                                                                                                                                                                        
read _input
sudo patch  -b -V simple ~/galaxy/universe_wsgi.ini universe_wsgi.ini.patch

