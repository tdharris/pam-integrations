#!/bin/sh
sqlplus sys/"$ORACLE_PWD"@//localhost:1521/"$ORACLE_SID" as sysdba <<-EOSQL

-- Run SQL script against the PDB, not the default CDB
ALTER SESSION SET CONTAINER = "$ORACLE_PDB";

-- Disable password expiration in default profile
ALTER PROFILE "DEFAULT" LIMIT PASSWORD_VERIFY_FUNCTION NULL;

-- Create TABLESPACE
CREATE TABLESPACE "$ORACLE_DATABASE";

-- dbadmin
CREATE USER dbadmin identified by "$ORACLE_PASSWORD" DEFAULT TABLESPACE example;
GRANT DBA to dbadmin;

-- Create users
CREATE USER dbuser1 identified by "$ORACLE_PASSWORD" DEFAULT TABLESPACE example;
CREATE USER dbuser2 identified by "$ORACLE_PASSWORD" DEFAULT TABLESPACE example;
CREATE USER dbuser3 identified by "$ORACLE_PASSWORD" DEFAULT TABLESPACE example;

-- Permissions for users
GRANT CREATE SESSION,
    CREATE TABLE,
    CREATE SEQUENCE,
    CREATE VIEW,
    CREATE PROCEDURE
    to dbuser1, dbuser2, dbuser3;

-- Possible need to give unlimited quota to default tablespace?

COMMIT;

EOSQL
