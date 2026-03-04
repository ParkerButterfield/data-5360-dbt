{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}


select
EMPLOYEE_ID as Employee_Key,
EMPLOYEE_ID as Employee_ID,
FIRST_NAME as FirstName,
LAST_NAME as LastName,
EMAIL as Email,
PHONE_NUMBER as Phone_Number,
HIRE_DATE as Hire_Date,
POSITION as Position
FROM {{ source('oliver_landing', 'employee') }}