{{ config(
    materialized = 'table',
    schema = 'DW_ECOESSENTIALS'
)}}

with campaigns as (

    select
        cast(campaign_id as varchar) as campaign_id,
        campaign_name,
        campaign_discount
    from {{ source('transactional', 'PROMOTIONAL_CAMPAIGN') }}
    where _fivetran_deleted = false

    union

    select distinct
        cast(campaignid as varchar) as campaign_id,
        campaignname as campaign_name,
        null as campaign_discount
    from {{ source('marketing', 'MARKETINGEMAILS') }}

)

select distinct
    {{ dbt_utils.generate_surrogate_key(['campaign_id']) }} as campaign_key,
    campaign_id,
    campaign_name,
    campaign_discount
from campaigns
where campaign_id is not null