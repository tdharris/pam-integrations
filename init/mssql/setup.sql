CREATE DATABASE example;
GO
USE example;
GO
-- Create dbadmin
CREATE USER dbadmin FOR LOGIN dbadmin;
CREATE LOGIN dbadmin WITH PASSWORD = 'Novell123';
EXEC sp_addsrvrolemember 'dbadmin', 'sysadmin';
GO
-- Create dbuser1
CREATE USER dbuser1 FOR LOGIN dbuser1;
CREATE LOGIN dbuser1 WITH PASSWORD = 'Novell123'; 
EXEC sp_addrolemember 'db_ddladmin', 'dbuser1';
GO
-- Create dbuser2
CREATE USER dbuser2 FOR LOGIN dbuser2;
CREATE LOGIN dbuser2 WITH PASSWORD = 'Novell123';
EXEC sp_addrolemember 'db_ddladmin', 'dbuser2';
GO
-- Create dbuser3
CREATE USER dbuser3 FOR LOGIN dbuser3;
CREATE LOGIN dbuser3 WITH PASSWORD = 'Novell123';
EXEC sp_addrolemember 'db_ddladmin', 'dbuser3';
GO
EXIT