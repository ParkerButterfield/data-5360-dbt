{{ config(
    materialized = 'table',
    schema = 'DW_ECOESSENTIALS'
)}}

select distinct
    {{ dbt_utils.generate_surrogate_key(['cast(emailid as varchar)']) }} as email_key,
    emailid as email_id,
    emailname as email_name
from {{ source('marketing', 'MARKETINGEMAILS') }}
where emailid is not null