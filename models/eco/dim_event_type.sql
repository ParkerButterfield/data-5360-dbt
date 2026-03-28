{{ config(
    materialized = 'table',
    schema = 'DW_ECOESSENTIALS'
)}}

select distinct
    {{ dbt_utils.generate_surrogate_key(['eventtype']) }} as event_type_key,
    eventtype as event_type
from {{ source('marketing', 'MARKETINGEMAILS') }}
where eventtype is not null