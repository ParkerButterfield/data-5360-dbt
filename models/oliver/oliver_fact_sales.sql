{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

SELECT
    c.Customer_Key,
    d.date_key,
    s.Store_Key,
    p.Product_Key,
    e.Employee_Key,
    ol.Unit_price,
    ol.Quantity,
    ol.Quantity * ol.Unit_price as Dollars_Sold
FROM {{ source('oliver_landing', 'orderline') }} ol
INNER JOIN {{ source('oliver_landing', 'orders') }} o ON o.order_ID = ol.order_ID
INNER JOIN {{ ref('oliver_dim_product') }} p ON ol.Product_ID = p.Product_ID
INNER JOIN {{ ref('oliver_dim_store') }} s ON s.Store_ID = o.Store_ID
INNER JOIN {{ ref('oliver_dim_customer') }} c ON o.Customer_ID = c.Customer_ID
INNER JOIN {{ ref('oliver_dim_employee') }} e ON e.Employee_ID = o.Employee_ID
INNER JOIN {{ ref('oliver_dim_date') }} d ON d.date_key = o.order_date
