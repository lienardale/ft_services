FROM alpine:latest

# # Config of PHP7 (https://wiki.alpinelinux.org/wiki/Nginx_with_PHP#PHP7_Installation)
# ENV PHP_FPM_USER="www"
# ENV PHP_FPM_GROUP="www"
# ENV PHP_FPM_LISTEN_MODE="0660"
# ENV PHP_MEMORY_LIMIT="512M"
# ENV PHP_MAX_UPLOAD="50M"
# ENV PHP_MAX_FILE_UPLOAD="200"
# ENV PHP_MAX_POST="100M"
# ENV PHP_DISPLAY_ERRORS="On"
# ENV PHP_DISPLAY_STARTUP_ERRORS="On"
# ENV PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
# ENV PHP_CGI_FIX_PATHINFO=0

# RUN adduser -D -g 'www' www
COPY config.inc.php setup.sh default.conf www.conf php.ini ./


# Install PHP
RUN apk update && \
	# apk add nginx && \
	# mkdir -p /run/nginx/ && \
	apk add --no-cache php7 php7-fpm php7-opcache php7-gd php7-mysqli \
	php7-zlib php7-curl php7-mbstring php7-json php7-session

# Download PHPMyAdmin
ADD https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz .

# Install PHPMyAdmin
RUN tar -xvf phpMyAdmin-5.0.2-english.tar.gz && \
	mv phpMyAdmin-5.0.2-english /var/www && \
	mv config.inc.php /var/www/ && \
	rm -f phpMyAdmin-5.0.2-english.tar.gz

# RUN mv default.conf /etc/nginx/conf.d/

EXPOSE 5000

CMD ./setup.sh
# CMD nginx -g 'daemon off;'
# CMD tail -f /dev/null
