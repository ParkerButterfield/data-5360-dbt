{{ config(
    materialized = 'table',
    schema = 'DW_ECOESSENTIALS'
)}}

select
    d.date_key,
    c.customer_key,
    p.product_key,
    camp.campaign_key,
    o.order_id,
    ol.quantity,
    (ol.quantity * pr.price) as gross_sales_amount,
    ol.discount as discount_amount,
    ol.price_after_discount as net_sales_amount
from {{ source('transactional', 'ORDER_LINE') }} ol
inner join "PARKERBUTTERFIELD"."ECO_DW_SOURCE_ECOESSENTIALS_TRANSACTIONAL_DB"."ORDER" o
    on ol.order_id = o.order_id
inner join {{ source('transactional', 'PRODUCT') }} pr
    on ol.product_id = pr.product_id
inner join {{ ref('dim_product') }} p
    on ol.product_id = p.product_id
inner join {{ ref('dim_campaign') }} camp
    on cast(ol.campaign_id as varchar) = camp.campaign_id
inner join {{ ref('dim_customer') }} c
    on {{ dbt_utils.generate_surrogate_key([
        "cast(o.customer_id as varchar)",
        "'TRANSACTIONAL'"
    ]) }} = c.customer_key
inner join {{ ref('dim_date') }} d
    on cast(o.order_timestamp as date) = d.date_key
where ol._fivetran_deleted = false
  and o._fivetran_deleted = false
  and pr._fivetran_deleted = false