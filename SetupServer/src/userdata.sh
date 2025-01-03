#!/bin/bash
sudo apt update -y
sudo snap install aws-cli --classic
sudo apt install apache2 -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt install php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-intl -y
sudo apt install curl php8.2-cli php8.2-mbstring git unzip -y
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
sudo apt install php8.2-xml php8.2-dom php8.2-simplexml -y
sudo apt install php8.2-pdo-mysql -y
sudo apt-get install libapache2-mod-php8.2 -y
sudo apt install git
