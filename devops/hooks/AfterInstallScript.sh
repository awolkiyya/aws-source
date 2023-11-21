#!/bin/bash
# Author Eng. Awol Abdulbaasit
# Runs inside production server.
export WEB_DIR="/var/www/html/"
domain_name="www.ghioon.com"
export email_address="awolabdulbaasit143@gmail.com"
# Your server user. Used to fix permission issue & install our project dependcies
export WEB_USER="ubuntu"

# Change directory to project.
cd $WEB_DIR
# change user owner to ubuntu & fix storage permission issues.
sudo chown -R ubuntu:ubuntu .
sudo chown -R www-data storage
sudo chmod -R u+x .
sudo chmod g+w -R storage
# install composer dependcies
sudo -u $WEB_USER composer install --no-dev --no-progress --prefer-dist
# Not used anywhere. Just helps you set up apache2 conf, disable default site and enable new site. Change variables.
APACHE_DIR="/etc/apache2"
CONFIG_FILE_NAME="ghioon-site.conf"
WEBSITE_DIR="/var/www/html/"
SERVER_ADMIN="awolabdulbaasit143@gmail.com"
# were using our server public ip. If you want to use a domain, make sure to
# change those values
SERVER_NAME="www.ghioon.com"
SERVER_ALIAS=$(wget -qO- ifconfig.me/ip)

cd $APACHE_DIR/sites-availiable

echo "<VirtualHost *:80>" > $CONFIG_FILE_NAME
echo "  ServerAdmin $SERVER_ADMIN" >> $CONFIG_FILE_NAME
echo "  ServerName $SERVER_NAME" >> $CONFIG_FILE_NAME
echo "  ServerAlias $SERVER_ALIAS" >> $CONFIG_FILE_NAME
echo "  DocumentRoot $WEBSITE_DIR/public" >> $CONFIG_FILE_NAME
echo "  ErrorLog ${APACHE_LOG_DIR}/error.log" >> $CONFIG_FILE_NAME
echo "  CustomLog ${APACHE_LOG_DIR}/access.log combined" >> $CONFIG_FILE_NAME
echo "  <Directory $WEBSITE_DIR>" >> $CONFIG_FILE_NAME
echo "    Require all granted" >> $CONFIG_FILE_NAME
echo "    AllowOverride All" >> $CONFIG_FILE_NAME
echo "    Options Indexes Multiviews FollowSymLinks" >> $CONFIG_FILE_NAME
echo "  </Directory>" >> $CONFIG_FILE_NAME 
echo "</VirtualHost>" >> $CONFIG_FILE_NAME

# disable default site + enable new site
sudo a2dissite 000-default.conf
sudo a2ensite $CONFIG_FILE_NAME

# enable rewrite module
sudo a2enmod rewrite

# restart apache
sudo /etc/init.d/apache2 restart
sudo apt-get update
# Domain and SSL Configuration
sudo apt install -y certbot python3-certbot-apache
# obtain ssl certificate
sudo certbot certonly --apache --domain $domain_name --email $email_address
sudo certbot renew --dry-run
sudo service apache2 restart
sudo crontab -e
# #update the .env file
cd /var/www/html/
cp .env.example .env
nano .env
#write into them
DB_CONNECTION=mysql
DB_HOST=ghioon-database-instance.c82w84bevr10.us-east-1.rds.amazonaws.com
DB_PORT=3306
DB_DATABASE=ghioon_database
DB_USERNAME=admin
DB_PASSWORD=admin2016
APP_URL=https://www.ghioon.com
# generate app key & run migrations
sudo -u $WEB_USER php artisan key:generate
sudo -u $WEB_USER php artisan migrate --force --no-interaction