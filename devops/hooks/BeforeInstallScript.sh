#!/bin/bash
# Exit on error
set -o errexit -o pipefail
# Update the system
sudo apt-get update && sudo apt-get upgrade -y
# Install important packages 
sudo apt -y install php-curl
sudo apt-get install -y git
sudo apt-get install -y unzip
sudo apt-get install -y zip
# Remove current apache & php
sudo apt-get -y remove apache2* php*
# Install the necessary prerequisites:
sudo apt install -y ca-certificates apt-transport-https software-properties-common
# Add the Ondřej Surý PPA to your system:
sudo add-apt-repository  ppa:ondrej/php -y
# Update the package index again:
sudo apt update -y
# Install Apache2 WebServer
sudo apt-get install -y apache2
# Install PHP 8.1 and mysql server to create the databes in RDS server
sudo apt install -y php8.1 php8.1-cli php8.1-fpm php8.1-mysql php8.1-xml php8.1-curl php8.1-opcache php8.1-common php8.1-gd  php8.1-mbstring php8.1-imap  php8.1-mcrypt
sudo apt-get -y install php8.1-apcu
# Get Composer, and install to /usr/local/bin
if [ ! -f "/usr/local/bin/composer" ]; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --install-dir=/usr/bin --filename=composer
    php -r "unlink('composer-setup.php');"
else
    /usr/local/bin/composer self-update --stable --no-ansi --no-interaction
fi
# Move to the web directory (e.g., /var/www/html)
cd /var/www/html/
# remove the index.html
sudo rm index.html
# and disable the site and remove available site from here before the app is installed