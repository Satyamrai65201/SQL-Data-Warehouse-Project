/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/


USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO
PRINT 'DATABASE CREATED';
GO

USE DataWarehouse;
GO
PRINT''
PRINT 'SCHEMA CREATION STARTED';
GO

-- Create BRONZE schema
CREATE SCHEMA bronze;
GO
PRINT''
PRINT 'BRONZE SCHEMA CREATED';
GO

-- Create SILVER schema
CREATE SCHEMA silver;
GO
PRINT''
PRINT 'SILVER SCHEMA CREATED';
GO

-- Create GOLD schema
CREATE SCHEMA gold;
GO
PRINT''
PRINT 'GOLD SCHEMA CREATED';
GO
