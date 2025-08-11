
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