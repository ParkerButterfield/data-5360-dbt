{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

SELECT
    d.date_key,
    e.employee_key,
    ec.certification_name,
    ec.certification_cost
FROM {{ ref('stg_employee_certifications') }} ec
INNER JOIN {{ ref('oliver_dim_employee') }} e ON ec.employee_id = e.employee_id
INNER JOIN {{ ref('oliver_dim_date') }} d ON d.date_key = ec.certification_awarded_date