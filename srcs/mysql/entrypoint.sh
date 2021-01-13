#!/bin/sh

# rc-update add mariadb default
# if [ ! -d /var/lib/mysql/wordpress ]
# then
# 	(
# 	mysql_install_db --user=mysql --datadir=${DB_DATA_PATH}
# 	rc-update add mariadb default
# 	rc boot && rc-service mariadb start 
# 	mysql --execute="create database wordpress default character set utf8 collate utf8_unicode_ci" 
# 	mysql --execute="grant all on *.* to 'root'@'%' identified by 'root'"
# 	mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'owen'@'%' IDENTIFIED BY 'owen'"
# 	mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' IDENTIFIED BY 'test'"
# 	mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'hanni'@'%' IDENTIFIED BY 'hanni'"
# 	mysql --execute="flush privileges" 
# 	mysql -uroot -proot wordpress < wordpress.sql
# 	)
# else
# 	mysql -uroot -proot wordpress < wp_users.sql
# 	rc boot && rc-service mariadb start
# fi	
# rc-service mariadb restart 

mysql_install_db --user=root --datadir=/var/lib/mysql
sed -i 's/skip-networking/# skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
mysqld --user=root &
sleep 4
mysql -u root < /home/wp.sql
kill `pgrep -x mysqld`
mysqld --user=root

sleep infinity