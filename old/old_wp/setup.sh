
# Run PHP specifying port and file location
# /usr/bin/php -S 0.0.0.0:80 -t /www/
php-fpm7 && nginx -g 'daemon off;'
