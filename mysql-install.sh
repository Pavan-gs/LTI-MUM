#!/bin/bash

# Update packages
apt-get update -y

# Install MySQL Server
DEBIAN_FRONTEND=noninteractive apt-get install mysql-server -y

# Start and enable MySQL
systemctl start mysql
systemctl enable mysql

# Secure MySQL (basic)
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Root@1234';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "FLUSH PRIVILEGES;"

# Create database and user
mysql -uroot -pRoot@1234 <<EOF
CREATE DATABASE demo_db;
CREATE USER 'demo_user'@'%' IDENTIFIED BY 'Password@123';
GRANT ALL PRIVILEGES ON demo_db.* TO 'demo_user'@'%';
FLUSH PRIVILEGES;
EOF

# Allow remote connections
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
