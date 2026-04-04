{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

SELECT
    -- Keys
    fs.customer_key,
    fs.date_key,
    fs.store_key,
    fs.product_key,
    fs.employee_key,

    -- Date
    dd.date_id,
    dd.dayofweek,
    dd.month,
    dd.quarter,
    dd.year,

    -- Customer
    dc.customer_id,
    dc.firstname AS customer_firstname,
    dc.lastname AS customer_lastname,
    dc.email AS customer_email,
    dc.phonenumber AS customer_phonenumber,
    dc.state AS customer_state,

    -- Employee
    de.employee_id,
    de.firstname AS employee_firstname,
    de.lastname AS employee_lastname,
    de.email AS employee_email,
    de.phone_number AS employee_phone_number,
    de.hire_date,
    de.position,

    -- Product
    dp.product_id,
    dp.product_name,
    dp.description AS product_description,

    -- Store
    ds.store_id,
    ds.store_name,
    ds.street AS store_street,
    ds.city AS store_city,
    ds.state AS store_state,

    -- Measures
    fs.unit_price,
    fs.quantity,
    fs.dollars_sold

FROM {{ ref('oliver_fact_sales') }} fs
LEFT JOIN {{ ref('oliver_dim_customer') }} dc ON fs.customer_key = dc.customer_key
LEFT JOIN {{ ref('oliver_dim_date') }} dd ON fs.date_key = dd.date_key
LEFT JOIN {{ ref('oliver_dim_employee') }} de ON fs.employee_key = de.employee_key
LEFT JOIN {{ ref('oliver_dim_product') }} dp ON fs.product_key = dp.product_key
LEFT JOIN {{ ref('oliver_dim_store') }} ds ON fs.store_key = ds.store_key