
# Add a private_html directory and redirect for the specified user
# This script must be run as superuser and is intended for use with a single user on the server 
# The html will be accesible to any valid server user
#
#   e.g. usage:  sudo sh add_private_html.sh ubuntu
#
# This script assumes that we are using a GVL image with a pre-configured config file.
# This is usually achieved by running configure_nginx.sh first.

# Modified by Andrew Lonsdale from orignal by:
#
# Clare Sloggett, VLSCI, University of Melbourne
# Authored as part of the Genomics Virtual Laboratory project
#


conf_file="/usr/nginx/conf/private_html.conf"
username=$1
redirect="/dashboard/"

if [ -z "$1" ]; then
    echo "Require username on command line"
    exit 1
fi

sudo su $username -c 'mkdir ~/private_html'
sudo su $username -c 'chmod 755 ~/private_html'

# Check if this user already exists in conf file

if [ $(grep $redirect $conf_file | wc -l) != '0' ]; then
    echo "Server appears to already have a shared private area in "$conf_file"; aborting."
    exit 1
fi

# Add redirect

cat >> $conf_file << END
location $redirect {
     auth_pam    "GVL Dashboard";
     auth_pam_service_name   "nginx";
     alias /home/$username/private_html/;
}
END

/usr/nginx/sbin/nginx -s reload
