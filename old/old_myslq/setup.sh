rc-update add mariadb default
if [ ! -d /var/lib/mysql/wordpress ]
then
	(
	mysql_install_db --user=mysql --datadir=${DB_DATA_PATH}
	rc-update add mariadb default
	rc boot && rc-service mariadb start 
	mysql --execute="create database wordpress default character set utf8 collate utf8_unicode_ci" 
	mysql --execute="grant all on *.* to 'wp_user'@'%' identified by '1010'"
    mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'alex'@'%' IDENTIFIED BY 'alex'"
	mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'owen'@'%' IDENTIFIED BY 'owen'"
	mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' IDENTIFIED BY 'test'"
	mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'hanni'@'%' IDENTIFIED BY 'hanni'"
	mysql --execute="flush privileges" 
	mysql -uroot -proot wordpress < wordpress.sql
	)
else
	mysql -uroot -proot wordpress < wp_users.sql
	rc boot && rc-service mariadb start
fi	
rc-service mariadb restart 

# # Setup MySQL
# /usr/bin/mysql_install_db --datadir=/var/lib/mysql

# # Start MySQL in background
# /usr/bin/mysqld --user=wp_user --init_file=/init_file & sleep 3

# # Initialize database
# mysql wordpress -u wp_user < wordpress.sql

# # Keep container running
tail -f /dev/null
