CREATE DATABASE example;
GO
SET NOCOUNT ON;
GO
USE example;
GO
-- Create dbadmin
CREATE LOGIN dbadmin WITH PASSWORD = 'Novell123';
CREATE USER dbadmin FOR LOGIN dbadmin;
EXEC sp_addsrvrolemember 'dbadmin', 'sysadmin';
GO
-- Create dbuser
CREATE LOGIN dbuser1 WITH PASSWORD = 'Novell123'; 
CREATE USER dbuser1 FOR LOGIN dbuser1;
EXEC sp_addrolemember 'db_ddladmin', 'dbuser1';
GO
-- Create dbuser2
CREATE LOGIN dbuser2 WITH PASSWORD = 'Novell123';
CREATE USER dbuser2 FOR LOGIN dbuser2;
EXEC sp_addrolemember 'db_ddladmin', 'dbuser2';
GO
-- Create dbuser3
CREATE LOGIN dbuser3 WITH PASSWORD = 'Novell123';
CREATE USER dbuser3 FOR LOGIN dbuser3;
EXEC sp_addrolemember 'db_ddladmin', 'dbuser3';
GO
EXIT