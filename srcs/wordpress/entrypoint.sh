cp www.conf etc/php7/php-fpm.d/www.conf
cp php-fpm.conf etc/php7/php-fpm.conf
cp php.ini etc/php7/php.ini
cp wp-config.php /var/www/WP/wp-config.php
cp -r /var/www/wordpress/* /var/www/WP && rm -rf var/www/wordpress

php-fpm7 && nginx -g 'daemon off;'

# cp wp-config.php /var/www/wordpress/wp-config.php