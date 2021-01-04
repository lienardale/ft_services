FROM alpine:latest

COPY wp-config.php setup.sh ./

# Install PHP
RUN apk update && \
	# apk add nginx && \
	# mkdir -p /run/nginx/ && \
	apk add --no-cache php7 php7-fpm php7-opcache php7-gd php7-mysqli \
	php7-zlib php7-curl php7-mbstring php7-json php7-session

# Download Wordpress
ADD https://wordpress.org/latest.tar.gz .

# Install Wordpress
RUN tar -xvf latest.tar.gz && \
	mv wordpress /www && \
	mv wp-config.php /www/ && \
	rm -f latest.tar.gz

# ADD default.conf /etc/nginx/conf.d/default.conf

EXPOSE 5050

CMD ./setup.sh
# CMD nginx -g 'daemon off;'
# CMD tail -f /dev/null
