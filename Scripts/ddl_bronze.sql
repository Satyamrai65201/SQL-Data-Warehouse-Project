/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/


USE DataWarehouse;
GO

-- ========== CRM Customer Info ==========
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_cust_info;
    PRINT 'Dropped table bronze.crm_cust_info';
END
GO

PRINT 'Creating table bronze.crm_cust_info';
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);
GO

PRINT 'Created table bronze.crm_cust_info';
GO

-- ========== CRM Product Info ==========
IF OBJECT_ID('bronze.crm_prod_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_prod_info;
    PRINT 'Dropped table bronze.crm_prod_info';
END
GO

PRINT 'Creating table bronze.crm_prod_info';
GO

CREATE TABLE bronze.crm_prod_info (
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);
GO

PRINT 'Created table bronze.crm_prod_info';
GO

-- ========== CRM Sales Details ==========
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_sales_details;
    PRINT 'Dropped table bronze.crm_sales_details';
END
GO

PRINT 'Creating table bronze.crm_sales_details';
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);
GO

PRINT 'Created table bronze.crm_sales_details';
GO

-- ========== ERP Customer AZ12 ==========
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_cust_az12;
    PRINT 'Dropped table bronze.erp_cust_az_12';
END
GO

PRINT 'Creating table bronze.erp_cust_az12';
GO

CREATE TABLE bronze.erp_cust_az12 (
    CID NVARCHAR(50),
    BDATE DATE,
    GEN NVARCHAR(50)
);
GO

PRINT 'Created table bronze.erp_cust_az_12';
GO

-- ========== ERP Location A101 ==========
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_loc_a101;
    PRINT 'Dropped table bronze.erp_loc_a101';
END
GO

PRINT 'Creating table bronze.erp_loc_a101';
GO

CREATE TABLE bronze.erp_loc_a101 (
    CID NVARCHAR(50),
    CNTRY NVARCHAR(50)
);
GO

PRINT 'Created table bronze.erp_loc_a101';
GO

-- ========== ERP PX Category G1V2 ==========
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_px_cat_g1v2;
    PRINT 'Dropped table bronze.erp_px_cat_g1v2';
END
GO

PRINT 'Creating table bronze.erp_px_cat_g1v2';
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    ID NVARCHAR(50),
    CAT NVARCHAR(50),
    SUBCAT NVARCHAR(50),
    MAINTENANCE NVARCHAR(50)
);
GO

PRINT 'Created table bronze.erp_px_cat_g1v2';
GO
