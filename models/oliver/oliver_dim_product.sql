{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}


SELECT
PRODUCT_ID as Product_Key,
PRODUCT_ID as Product_ID,
DESCRIPTION as Description,
PRODUCT_NAME as Product_Name
FROM {{ source('oliver_landing', 'product') }}