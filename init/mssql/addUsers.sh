#!/bin/bash

# Run the setup script to create users only once
if [ ! -f "/docker-entrypoint-initdb.d/setup.completed" ]; then
    sleep 5
    for i in {1..90};
    do
        /opt/mssql-tools/bin/sqlcmd -S localhost,1234 -U sa -P "${MSSQL_SA_PASSWORD}" -d master -i "/docker-entrypoint-initdb.d/setup.sql"
        if [ $? -eq 0 ]
        then
            echo "[initdb] setup.sql completed"
            touch "/docker-entrypoint-initdb.d/setup.completed"
            break
        else
            echo "[initdb] not ready yet..."
            sleep 1
        fi
    done
fi