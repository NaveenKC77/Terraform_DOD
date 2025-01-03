#!/bin/bash

# Update system
sudo apt update -y

# Install AWS CLI
sudo snap install aws-cli --classic

# Install Apache2
sudo apt install apache2 -y

# Start Apache2
sudo systemctl start apache2

# Sync files from S3 bucket
sudo aws s3 sync s3://<bucket name>/DOD_S3 /var/www/html

# Set permissions for web directory

sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 775 /var/www/html

# Install PHP 8.2.12
sudo add-apt-repository ppa:ondrej/php -y
sudo apt install php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-intl -y

# Install Composer
sudo apt install curl php8.2-cli php8.2-mbstring git unzip -y
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# PHP INI configuration
sudo apt install php8.2-xml php8.2-dom php8.2-simplexml -y

# Install PDO extension
sudo apt install php8.2-pdo-mysql -y

# get to the directory
cd /var/www/html

# Install dependencies using Composer
sudo composer install --no-interaction

# Execute Phing build
sudo php ./vendor/bin/phing build

# Restart Apache2
sudo systemctl restart apache2

# Get configuration file from S3
aws s3 cp s3://<bucket name>/000-default.conf /tmp/000-default.conf

# Move and replace 000-default.conf
sudo mv /tmp/000-default.conf /etc/apache2/sites-available/000-default.conf

# Install PHP module for Apache
sudo apt-get install libapache2-mod-php8.2 -y

# Enable Apache rewrite module
sudo a2enmod rewrite

# Restart Apache2
sudo systemctl restart apache2
