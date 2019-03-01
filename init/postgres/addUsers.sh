#!/bin/bash
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	-- dbuser1
	CREATE USER dbuser1 WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
	GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO dbuser1;
	-- dbuser2
	CREATE USER dbuser2 WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
	GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO dbuser2;
	-- dbuser3
	CREATE USER dbuser3 WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
	GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO dbuser3;
EOSQL
