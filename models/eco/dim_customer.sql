{{ config(
    materialized = 'table',
    schema = 'DW_ECOESSENTIALS'
)}}

with transactional_customers as (

    select
        {{ dbt_utils.generate_surrogate_key([
            "cast(customer_id as varchar)",
            "'TRANSACTIONAL'"
        ]) }} as customer_key,
        cast(customer_id as varchar) as customer_id,
        null as subscriber_id,
        customer_first_name as first_name,
        customer_last_name as last_name,
        customer_phone as phone,
        customer_address as address,
        customer_city as city,
        customer_state as state,
        customer_zip as zip,
        customer_country as country,
        customer_email as email
    from {{ source('transactional', 'CUSTOMER') }}
    where _fivetran_deleted = false

),

marketing_customers as (

    select distinct
        {{ dbt_utils.generate_surrogate_key([
            "coalesce(cast(customerid as varchar), cast(subscriberid as varchar), subscriberemail)",
            "'MARKETING'"
        ]) }} as customer_key,
        cast(customerid as varchar) as customer_id,
        cast(subscriberid as varchar) as subscriber_id,
        subscriberfirstname as first_name,
        subscriberlastname as last_name,
        null as phone,
        null as address,
        null as city,
        null as state,
        null as zip,
        null as country,
        subscriberemail as email
    from {{ source('marketing', 'MARKETINGEMAILS') }}

),

all_customers as (

    select * from transactional_customers
    union all
    select * from marketing_customers

),

deduped as (

    select
        *,
        row_number() over (
            partition by customer_key
            order by
                case when email is not null then 0 else 1 end,
                case when customer_id is not null then 0 else 1 end,
                last_name,
                first_name
        ) as rn
    from all_customers

)

select
    customer_key,
    customer_id,
    subscriber_id,
    first_name,
    last_name,
    phone,
    address,
    city,
    state,
    zip,
    country,
    email
from deduped
where rn = 1