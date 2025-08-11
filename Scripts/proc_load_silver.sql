
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



