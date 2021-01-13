FROM alpine:latest

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

ADD php-fpm.conf .
ADD www.conf .
ADD php.ini .
ADD setup.sh .
ADD wp-config.php .

RUN chmod +x setup.sh
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/community/" >> /etc/apk/repositories

# Install PHP & nginx
RUN apk update && \
	apk add nginx && \
	mkdir -p /run/nginx/ && \
	mkdir -p /var/www/WP && \
	apk add --no-cache php7-fpm php7-mcrypt php7-soap php7-gmp \
    php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli \
    php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc \
    php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader \
    php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype \
    php7-session php7-mbstring php7-dev php7-openssl

# # Download Wordpress
RUN cd /var/www/ && wget http://wordpress.org/latest.tar.gz
# # Install Wordpress
RUN tar -xzvf /var/www/latest.tar.gz -C /var/www/

ADD default.conf /etc/nginx/conf.d/default.conf

RUN mv www.conf etc/php7/php-fpm.d/www.conf && \
	mv php-fpm.conf etc/php7/php-fpm.conf && \
	mv php.ini etc/php7/php.ini && \
	mv wp-config.php /var/www/WP/wp-config.php && \
	mv /var/www/wordpress/* /var/www/WP/ && rm -rf www/wordpress

EXPOSE 5050

CMD ./setup.sh
