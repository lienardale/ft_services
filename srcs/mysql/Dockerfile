FROM alpine

# ADD wordpress.sql ./wordpress.sql

# ADD wp_users.sql ./wp_users.sql
# # Only needed for testing

# RUN echo 'mysql -uroot -proot wordpress < wp_users.sql' > addusers.sh
# RUN echo 'mysql -uroot -proot wordpress < wordpress.sql' > addtable.sh
# RUN chmod +x addusers.sh
# RUN chmod +x addtable.sh

# RUN apk update && apk add mariadb mariadb-client openrc

# ENV DB_DATA_PATH /var/lib/mysql
# ENV DB_USER user
# ENV DB_PASS user 
# ENV MAX_ALLOWED_PACKET 200M 

# RUN mkdir -p ${DB_DATA_PATH}
# RUN chmod 777 ${DB_DATA_PATH}

# COPY mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

#---Setting repos---
RUN apk update

#---install mysql---
RUN apk add mysql 
RUN apk add mysql-client

#---setup---
RUN mkdir -p /run/mysqld
COPY wp.sql /home/wp.sql
# COPY setup_mysql.sh /home
# ENTRYPOINT ["sh", "/home/setup_mysql.sh"] 

COPY entrypoint.sh /

EXPOSE 3306

CMD sh entrypoint.sh
