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

    union all

    select distinct
        cast(campaignid as varchar) as campaign_id,
        campaignname as campaign_name,
        null as campaign_discount
    from {{ source('marketing', 'MARKETINGEMAILS') }}

),

deduped as (

    select
        {{ dbt_utils.generate_surrogate_key(['campaign_id']) }} as campaign_key,
        campaign_id,
        campaign_name,
        campaign_discount,
        row_number() over (
            partition by campaign_id
            order by
                case when campaign_discount is not null then 0 else 1 end,
                campaign_name
        ) as rn
    from campaigns
    where campaign_id is not null

)

select
    campaign_key,
    campaign_id,
    campaign_name,
    campaign_discount
from deduped
where rn = 1