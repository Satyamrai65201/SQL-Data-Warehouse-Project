CREATE VIEW gold.dim_customers AS
select
ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
ci.cst_id   AS customer_id,
ci.cst_key  AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname  AS last_name,
lo.CNTRY AS country,
ci.cst_marital_status  AS marital_status,
CASE WHEN ci.cst_gndr !='n/a' THEN ci.cst_gndr----> CRM IS the master for gender 
	ELSE COALESCE(ca.gen,'n/a')
	END AS  gender,
ca.Bdate   AS birthdate,
ci.cst_create_date AS create_date 
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca on
ci.cst_key= ca.CID
left join silver.erp_loc_a101 lo
on ci.cst_key=lo.CID
