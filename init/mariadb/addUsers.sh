#!/bin/bash
mysql -u "root" --password="$MARIADB_ROOT_PASSWORD" <<-EOSQL
	-- dbuser1
	CREATE USER 'dbuser1'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
	GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO 'dbuser1'@'%';
	-- dbuser2
	CREATE USER 'dbuser2'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
	GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO 'dbuser2'@'%';
	-- dbuser3
	CREATE USER 'dbuser3'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
	GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO 'dbuser3'@'%';
	-- sometimes to take effect
	flush privileges
EOSQL
