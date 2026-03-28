{{ config(
    materialized = 'table',
    schema = 'DW_ECOESSENTIALS'
)}}

select
    {{ dbt_utils.generate_surrogate_key(['cast(product_id as varchar)']) }} as product_key,
    product_id,
    product_name,
    product_type
from {{ source('transactional', 'PRODUCT') }}
where _fivetran_deleted = false