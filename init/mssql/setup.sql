CREATE DATABASE example;
GO
USE example;
GO
-- Create dbuser1
CREATE LOGIN dbuser1 WITH PASSWORD = 'Novell123'; 
exec sp_addrolemember 'db_ddladmin', 'dbuser1';
GO
-- Create dbuser2
CREATE LOGIN dbuser2 WITH PASSWORD = 'Novell123';
exec sp_addrolemember 'db_ddladmin', 'dbuser2';
GO
-- Create dbuser3
CREATE LOGIN dbuser3 WITH PASSWORD = 'Novell123';
exec sp_addrolemember 'db_ddladmin', 'dbuser3';
GO
EXIT