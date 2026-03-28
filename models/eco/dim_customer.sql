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

)

select * from transactional_customers
union
select * from marketing_customers