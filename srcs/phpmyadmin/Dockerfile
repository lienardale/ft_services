FROM alpine:latest

# # Config of PHP7 (https://wiki.alpinelinux.org/wiki/Nginx_with_PHP#PHP7_Installation)
ENV PHP_FPM_USER="www"
ENV PHP_FPM_GROUP="www"
ENV PHP_FPM_LISTEN_MODE="0660"
ENV PHP_MEMORY_LIMIT="512M"
ENV PHP_MAX_UPLOAD="50M"
ENV PHP_MAX_FILE_UPLOAD="200"
ENV PHP_MAX_POST="100M"
ENV PHP_DISPLAY_ERRORS="On"
ENV PHP_DISPLAY_STARTUP_ERRORS="On"
ENV PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
ENV PHP_CGI_FIX_PATHINFO=0

RUN adduser -D -g 'www' www
COPY config.inc.php setup.sh default.conf www.conf php.ini php-fpm.conf ./

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/community/" >> /etc/apk/repositories

# Install PHP
RUN apk update && apk add nginx && \
	mkdir -p /run/nginx/ && \
	mkdir -p /var/www/PMA && \
	# chmod -R 777  /var/www/PMA && \
	apk add --no-cache php7 php7-fpm php7-opcache php7-gd php7-mysqli \
	php7-zlib php7-curl php7-mbstring php7-json php7-session \
	&& apk add openssl openssh

# Download PHPMyAdmin

RUN mkdir -p /usr/share/webapps/ && \
 	cd /usr/share/webapps && \
	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz && \
# Install PHPMyAdmin
	tar -xvf phpMyAdmin-5.0.2-english.tar.gz && \
	rm phpMyAdmin-5.0.2-english.tar.gz && \
	mv phpMyAdmin-5.0.2-english PMA && \
	chmod -R 777 /usr/share/webapps/

# ADD https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz .
RUN	cd && cd .. && \
	# cp -rf /usr/share/webapps/phpMyAdmin-5.0.2-english/ /var/www/ && \
	# chmod -R 777 /var/www/phpMyAdmin-5.0.2-english && \
	cp -rf /usr/share/webapps/PMA/ /var/www/ && \
	chmod -R 777 /var/www/PMA && \
	mv default.conf /etc/nginx/conf.d/ && \
	mv www.conf etc/php7/php-fpm.d/www.conf && \
	mv php-fpm.conf etc/php7/php-fpm.conf && \
	mv php.ini etc/php7/php.ini && \
	mkdir -p etc/phpmyadmin && \
	# mv config.inc.php var/www/phpMyAdmin-5.0.2-english
	mv config.inc.php /var/www/PMA

# Setup SSL
RUN openssl req -new -newkey rsa:2048 -nodes -days 365 -x509 \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=Federation/CN=localhost" \
	-keyout /etc/ssl/private/ssl.key -out /etc/ssl/certs/ssl.crt

EXPOSE 5000

CMD ./setup.sh
# CMD nginx -g 'daemon off;'
# CMD tail -f /dev/null
