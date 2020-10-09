-- Run SQL script against the PDB, not the default CDB
ALTER SESSION SET CONTAINER = "ORCLPDB1";

-- Disable password expiration in default profile
ALTER PROFILE "DEFAULT" LIMIT PASSWORD_VERIFY_FUNCTION NULL;

-- Create TABLESPACE
CREATE TABLESPACE example
datafile 'example.dbf'
size 5M AUTOEXTEND ON;

-- dbadmin
CREATE USER dbadmin identified by novell123 DEFAULT TABLESPACE example;
GRANT SYSDBA to dbadmin;

-- Create users
CREATE USER dbuser1 identified by novell123 DEFAULT TABLESPACE example;
CREATE USER dbuser2 identified by novell123 DEFAULT TABLESPACE example;
CREATE USER dbuser3 identified by novell123 DEFAULT TABLESPACE example;

-- Permissions for users
GRANT CONNECT, RESOURCE,
    CREATE SESSION,
    CREATE TABLE,
    CREATE SEQUENCE,
    CREATE VIEW,
    CREATE PROCEDURE
    to dbuser1, dbuser2, dbuser3;

-- Possible need to give unlimited quota to default tablespace?
ALTER USER dbadmin QUOTA UNLIMITED ON USERS;
ALTER USER dbuser1 QUOTA UNLIMITED ON USERS;
ALTER USER dbuser2 QUOTA UNLIMITED ON USERS;
ALTER USER dbuser3 QUOTA UNLIMITED ON USERS;

COMMIT;
