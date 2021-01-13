FROM alpine:latest

ADD wordpress.sql ./wordpress.sql

# ADD wp_users.sql ./wp_users.sql
# # Only needed for testing

# RUN echo 'mysql -uroot -proot wordpress < wp_users.sql' > addusers.sh
# RUN echo 'mysql -uroot -proot wordpress < wordpress.sql' > addtable.sh
# RUN chmod +x addusers.sh
# RUN chmod +x addtable.sh

RUN apk update && apk add mariadb mariadb-client openrc

ENV DB_DATA_PATH /var/lib/mysql
ENV DB_USER user
ENV DB_PASS user 
ENV MAX_ALLOWED_PACKET 200M 

RUN mkdir -p ${DB_DATA_PATH}
RUN chmod 777 ${DB_DATA_PATH}

COPY my.cnf /etc/my.cnf.d/my.cnf
COPY setup.sh /

EXPOSE 3306

CMD ./setup.sh
