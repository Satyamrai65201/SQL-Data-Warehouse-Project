
INSERT INTO silver.crm_cust_info(cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date)

SELECT cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
CASE
		WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) ='M' THEN 'Married'
		ELSE 'n/a'
END cst_marital_status-- Normalize marital status values to readable format
,
CASE
		WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) ='M' THEN 'Male'
		ELSE 'n/a'
END cst_gndr,-- Normalize gender values to readable format

cst_create_date
FROM 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION by cst_id ORDER by cst_create_date desc) as flag_last
 FROM bronze.crm_cust_info) t 
 WHERE t.flag_last=1-- Select the most recent record per customer


--------------------------------------------------------------------------------------------------------------

INSERT INTO silver.crm_prod_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
 SELECT [prd_id]
	,
	REPLACE(SUBSTRING([prd_key], 1, 5), '-', '_') AS cat_id  -- Extract category ID
	,SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key              -- Extract product key
	,[prd_nm]
	,ISNULL([prd_cost], 0) AS [prd_cost]
	,CASE UPPER(TRIM(prd_line))
		WHEN 'M'
			THEN 'Mountains'
		WHEN 'R'
			THEN 'Roads'
		WHEN 'S'
			THEN 'Other sales'
		WHEN 'T'
			THEN 'Touring'
		ELSE 'n\a'
		END AS [prd_line]   -- Map product line codes to descriptive values

	,CAST([prd_start_dt] AS DATE) AS [prd_start_dt]  

	,CAST(LEAD(prd_start_dt) OVER 
	(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS [prd_end_dt] -- Calculate end date as one day before the next start date

FROM [DataWarehouse].[bronze].[crm_prod_info]

--------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

INSERT INTO silver.crm_sales_details(  sls_ord_num,
    sls_prd_key,
    sls_cust_id ,
    sls_order_dt ,
    sls_ship_dt ,
    sls_due_dt,
    sls_sales ,
    sls_quantity ,
    sls_price )

SELECT  [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,
	    CASE WHEN  sls_order_dt=0 OR LEN(sls_order_dt)!=8 THEN NULL
			 ELSE CAST(CAST (sls_order_dt as VARCHAR) AS DATE)
		END AS [sls_order_dt]
      ,
	  CASE WHEN  sls_ship_dt=0 OR LEN(sls_ship_dt)!=8 THEN NULL
			 ELSE CAST(CAST (sls_ship_dt as VARCHAR) AS DATE)
		END AS [sls_ship_dt]
      ,
	  CASE WHEN  sls_due_dt=0 OR LEN(sls_due_dt)!=8 THEN NULL
			 ELSE CAST(CAST (sls_due_dt as VARCHAR) AS DATE)
		END AS sls_due_dt
      
      ,
	  CASE WHEN sls_sales is NULL OR sls_sales<=0 OR sls_sales!= sls_quantity*ABS(sls_price)
			THEN sls_quantity*ABS (sls_price)
			ELSE sls_sales
		END[sls_sales]  -- Recalculate sales if original value is missing or incorrect
      ,[sls_quantity]
      ,
	  CASE  WHEN sls_price is NULL OR sls_price<=0
	  THEN sls_sales/NULLIF(sls_quantity,0) 
	  ELSE sls_price -- Derive price if original value is invalid
	  END AS [sls_price]
  FROM [DataWarehouse].[bronze].[crm_sales_details]


-----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
INSERT INTO [silver].[erp_cust_az12]
(cid,bdate,gen)

SELECT 
		CASE WHEN  cid LIKE '%NAS%' THEN  SUBSTRING(cid,4,LEN(cid))
		ELSE cid
		END AS cid
      ,
	    CASE WHEN bdate> GETDATE()  THEN NULL
		ELSE bdate 
		END AS Bdate 
      ,CASE WHEN UPPER(TRIM(gen))  IN ('M','MALE') THEN 'Male '
	WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
	ELSE 'n/a'
	END AS gen
  FROM [DataWarehouse].[bronze].[erp_cust_az12]


  -------------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------

INSERT INTO DataWarehouse.silver.erp_loc_a101(
CID,
CNTRY)

SELECT 
	REPLACE(cid,'-','') as CID
      ,
	  
	  CASE WHEN TRIM(cntry) ='DE' THEN 'Germany'
	  WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
	  WHEN TRIM(cntry) =' ' OR Cntry IS  NULL THEN 'n\a'
	  ELSE TRIM(cntry)
	  END AS CNTRY
  FROM DataWarehouse.bronze.erp_loc_a101

  ----------------------------------------------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------------------------------------------
INSERT INTO silver.erp_px_cat_g1v2
(ID
,CAT
,SUBCAT
,MAINTENANCE)

SELECT ID
      ,CAT
      ,SUBCAT
      ,MAINTENANCE
  FROM DataWarehouse.bronze.erp_px_cat_g1v2
