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

--=======================================================================

CREATE VIEW gold.dim_products AS 
SELECT 
		ROW_NUMBER() OVER(ORDER BY c.prd_start_dt, c.prd_key) as product_key
	  ,c.prd_id AS product_id  
	  ,c.prd_key AS product_number
	  ,c.prd_nm AS product_name
      ,c.cat_id AS category_id
	  ,e.CAT AS category
	  ,e.SUBCAT AS subcategory
	  ,e.maintenance 
      ,c.prd_cost AS cost 
      ,c.prd_line AS product_line
      ,c.prd_start_dt AS start_date
	  
  FROM silver.crm_prd_info c
  left join silver.erp_px_cat_g1v2  e on  c.cat_id =e.id
  where prd_end_dt is NULL------ filter out all historical  data 

 --===========================================================================================================
CREATE VIEW gold.fact_sales AS
SELECT sls_ord_num AS order_number 
      ,pr.product_key 
      ,cu.customer_key
      ,sls_order_dt AS order_date
      ,sls_ship_dt AS shipping_date
      ,sls_due_dt AS due_date
      ,sls_sales AS sales_amount 
      ,sls_quantity AS quantity
      ,sls_price AS price
  FROM silver.crm_sales_details sd
  LEFT JOIN gold.dim_products pr 
  ON sd.sls_prd_key= pr.product_number
  LEFT JOIN gold.dim_customers cu 
  ON sd.sls_cust_id=cu.customer_id



