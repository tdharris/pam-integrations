# Run Microsoft SQl Server and initialization script (at the same time)
/docker-entrypoint-initdb.d/addUsers.sh & /opt/mssql/bin/sqlservr