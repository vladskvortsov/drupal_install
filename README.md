# Drupal install
Quick guide to install Drupal CMS.
You can install it manually or use script [drupal_install.sh][PlGh].

### Prerequisites

- Apache
- MariaDB
- PHP

## Step 1. Install Apache2 MariaDB PHP and additional packages.


```sh
sudo apt-get install -y apache2 mariadb-server mariadb-client php libapache2-mod-php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-intl php-mbstring php-curl php-xml php-pear php-tidy php-soap php-bcmath php-xmlrpc
``` 


## Step 2. Cofigure drupal database and user.

Run to enter mysql configuration, enter mysql root password if needed:
```sh
sudo mysql -u root -p
```
Then run following to create user "drupal" with password "drupal":
```sh
CREATE USER drupal@localhost IDENTIFIED BY "drupal";
```
Create drupal database and grant privileges:
```sh
create database drupal;
GRANT ALL ON drupal.* TO drupal@localhost;
FLUSH PRIVILEGES;
exit
```
## Step 3. Install drupal.

Use wget to download archive, then unpack it:

```sh
sudo wget https://www.drupal.org/download-latest/tar.gz -O drupal.tar.gz
sudo tar -xvf drupal.tar.gz
sudo mv drupal-*.* /var/www/html/drupal
```
Change priveleges: 
```sh
sudo chown -R www-data:www-data /var/www/html/drupal/
sudo chmod -R 755 /var/www/html/drupal/
```    
Add following in /etc/apache2/sites-available/drupal.conf to define
host name (in my case localhost):
```sh
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
```    
> Note: `You can use vim if you wish.

Enable site and restart apache server:
```sh
sudo a2ensite drupal.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
``` 
Then open your browser type host name and you be able to configure drupal in interactive mode.
