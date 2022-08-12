#!/bin/bash

echo 'Enter db root password:'
read -s dbpass

sudo apt-get update -y
sudo apt-get install  -y apache2 mariadb-server mariadb-client php libapache2-mod-php
sudo apt-get install  -y php-cli php-fpm php-json php-common php-mysql php-zip php-gd
sudo apt-get install -y php-intl php-mbstring php-curl php-xml php-pear php-tidy
sudo apt-get install -y php-soap php-bcmath php-xmlrpc 

#sudo mysql_secure_installation

sudo mysql -u root -p$dbpass<<'EOF'
CREATE USER drupal@localhost IDENTIFIED BY "drupal";
create database drupal;
GRANT ALL ON drupal.* TO drupal@localhost;
FLUSH PRIVILEGES;
EOF


sudo wget https://www.drupal.org/download-latest/tar.gz -O drupal.tar.gz

sudo tar -xvf drupal.tar.gz
sudo mv drupal-*.* /var/www/html/drupal

sudo chown -R www-data:www-data /var/www/html/drupal/
sudo chmod -R 755 /var/www/html/drupal/
sudo echo '<VirtualHost *:80>
     ServerAdmin admin@localhost
     DocumentRoot /var/www/html/drupal/
     ServerName  localhost  
     ServerAlias localhost

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined

     <Directory /var/www/html/drupal/>
            Options FollowSymlinks
            AllowOverride All
            Require all granted
     </Directory>

     <Directory /var/www/html/>
            RewriteEngine on
            RewriteBase /
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteRule ^(.*)$ index.php?q=$1 [L,QSA]
    </Directory>
</VirtualHost>' > /etc/apache2/sites-available/drupal.conf

sudo a2ensite drupal.conf
sudo a2enmod rewrite

sudo systemctl restart apache2
