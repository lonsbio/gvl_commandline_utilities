
# Install RStudio on a GLV instance.
# Assumes that configure_nginx.conf has been run to set up port forwarding.
# This script must be run with superuser permissions.

# Clare Sloggett, VLSCI, University of Melbourne
# Authored as part of the Genomics Virtual Laboratory project

echo "Installing RStudio and dependencies"

apt-get install gdebi-core
wget http://download2.rstudio.org/rstudio-server-0.98.501-amd64.deb
yes | gdebi rstudio-server-0.98.501-amd64.deb
rm rstudio-server-0.98.501-amd64.deb

echo "Writing NGINX config for RStudio"

cat > /usr/nginx/conf/rstudio_nginx.conf << END
location /rstudio/ {
  rewrite ^/rstudio/(.*)\$ /\$1 break;
  proxy_pass http://localhost:8787;
  proxy_redirect http://localhost:8787/ \$scheme://\$host/rstudio/;
}
END

/usr/nginx/sbin/nginx -s reload

echo "Configuring RStudio"

# Configure RStudio to allow only rstudio_users accounts, 
# which should not include superusers

addgroup rstudio_users

cat > /etc/rstudio/rserver.conf << END
auth-required-user-group=rstudio_users
END

rstudio-server restart