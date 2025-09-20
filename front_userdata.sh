#!bin/bash
yum update -y
yum install httpd php php-mysqli -y
cd /tmp/
wget https://wordpress.org/latest.tar.gz
tar xvzf latest.tar.gz
mv wordpress/* /var/www/html/
mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
chown -R apache:apache /var/www/html/ 
sed -i 's/database_name_here/wordpress/g' /var/www/html/wp-config.php
sed -i 's/username_here/wpuser/g' /var/www/html/wp-config.php
sed -i 's/password_here/password/g' /var/www/html/wp-config.php
sed -i 's/localhost/backend.jeethu.shop/g' /var/www/html/wp-config.php
systemctl restart httpd && systemctl status httpd
rm -rf /tmp/latest.tar.gz
