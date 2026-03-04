{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}


SELECT
STORE_ID as Store_Key,
STORE_ID as Store_ID,
STORE_NAME as Store_Name,
STREET as Street,
CITY as City,
STATE as State
FROM {{ source('oliver_landing', 'store') }}