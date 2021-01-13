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
ADD entrypoint.sh .
ADD wp-config.php .

ADD liveness.sh .
RUN chmod 777 liveness.sh

RUN chmod +x entrypoint.sh

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/community/" >> /etc/apk/repositories

RUN apk update

RUN apk add nginx php7-fpm php7-mcrypt php7-soap php7-gmp \
    php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli \
    php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc \
    php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader \
    php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype \
    php7-session php7-mbstring php7-dev php7-openssl php7-phar \
    && apk add openssl openssh

RUN mkdir -p /var/www/WP
RUN mkdir run/nginx

# install wordpress
RUN cd /var/www/ && wget http://wordpress.org/latest.tar.gz
RUN tar -xzvf /var/www/latest.tar.gz -C /var/www/

# install wp_cli
RUN apk add curl && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

ADD default.conf /etc/nginx/conf.d/default.conf

EXPOSE 5050

CMD ./entrypoint.sh
# CMD sh entrypoint.sh && /usr/sbin/sshd && php-fpm7 && nginx -g 'daemon off;' 