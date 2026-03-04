{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}


select
CUSTOMER_ID as Customer_Key,
CUSTOMER_ID as Customer_ID,
FIRST_NAME as FirstName,
LAST_NAME as LastName,
EMAIL as Email,
PHONE_NUMBER as PhoneNumber,
STATE as State
FROM {{ source('oliver_landing', 'customer') }}