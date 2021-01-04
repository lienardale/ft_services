FROM alpine:latest

# ADD 	srcs /srcs
COPY srcs/* srcs/

RUN apk update \
	&& apk upgrade \
	&& apk add nginx \
	&& apk add openssl openssh

# Setup nginx
RUN mkdir -p /run/nginx www && \
	cp srcs/nginx.conf /etc/nginx/conf.d/default.conf && \
	# mv srcs/nginx.conf /etc/nginx/ && \
	mv srcs/index.html /www/ && \
    mv srcs/run.sh . && \
    chmod 755 run.sh

# Setup SSL
RUN openssl req -new -newkey rsa:2048 -nodes -days 365 -x509 \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=Federation/CN=localhost" \
	-keyout /etc/ssl/private/ssl.key -out /etc/ssl/certs/ssl.crt

# Setup SSH
RUN ssh-keygen -A && adduser -D ssh_admin && echo "ssh_admin:0101" | chpasswd
# to test -> ssh ssh_admin@192.168.99.124
EXPOSE 80 443 22

CMD ./run.sh
