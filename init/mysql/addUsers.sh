#!/bin/bash
mysql -u "root" --password="$MYSQL_ROOT_PASSWORD" <<-EOSQL
	-- dbuser1
	CREATE USER 'dbuser1'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
	GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO 'dbuser1'@'%';
	-- dbuser2
	CREATE USER 'dbuser2'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
	GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO 'dbuser2'@'%';
	-- dbuser3
	CREATE USER 'dbuser3'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
	GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO 'dbuser3'@'%';
	-- sometimes to take effect
	flush privileges
EOSQL
