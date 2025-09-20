#!bin/bash
yum update -y
yum install mariadb1011-server -y
systemctl start mariadb && systemctl enable mariadb && systemctl status mariadb
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'popinz';"
mysql -u root -ppopinz -e "CREATE DATABASE wordpress;"
mysql -u root -ppopinz -e "CREATE USER wpuser IDENTIFIED BY 'password';"
 mysql -u root -ppopinz -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;"
mysql -u root -ppopinz -e 'FLUSH PRIVILEGES;'
