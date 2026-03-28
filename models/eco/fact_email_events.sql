{{ config(
    materialized = 'table',
    schema = 'DW_ECOESSENTIALS'
)}}

select
    c.customer_key,
    camp.campaign_key,
    d.date_key,
    et.event_type_key,
    e.email_key,
    m.eventtimestamp as event_timestamp
from {{ source('marketing', 'MARKETINGEMAILS') }} m
inner join {{ ref('dim_campaign') }} camp
    on cast(m.campaignid as varchar) = camp.campaign_id
inner join {{ ref('dim_email') }} e
    on m.emailid = e.email_id
inner join {{ ref('dim_event_type') }} et
    on m.eventtype = et.event_type
inner join {{ ref('dim_date') }} d
    on cast(m.eventtimestamp as date) = d.date_key
inner join {{ ref('dim_customer') }} c
    on {{ dbt_utils.generate_surrogate_key([
        "coalesce(cast(m.customerid as varchar), cast(m.subscriberid as varchar), m.subscriberemail)",
        "'MARKETING'"
    ]) }} = c.customer_key