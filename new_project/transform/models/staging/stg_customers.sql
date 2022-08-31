with source as (

    select * from {{ source('tap_s3_csv','raw_customers') }}

),

renamed as (

    select
        id as customer_id,
        first_name,
        last_name

    from source

)

select * from renamed
