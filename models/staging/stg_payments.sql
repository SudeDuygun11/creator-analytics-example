--storing the amount_eur as numeric so will be saved with 9 decimals because float64 doesnt make it precise. 
--BIGNUMERIC is another option for very large values. safe_cast gives null orinteger when a value is incovertable
--timestamp(created_at, 'Europe/Amsterdam') when the source stores local times. parse_timestamp('%d/%m/%Y %H:%M', created_at) for text in an unusual format. safe.parse_timestamp(...) returns NULL instead of an error.
--Add a tiebreaker: order by _loaded_at desc, some_other_column	Makes the choice deterministic when timestamps tie. Recommended in production.
--!!!! I dont know where the date column is from the understand i need to first take the timestamp which has UTC then i can convert the Amsterdam time and take the date part.
with source as (
    select * from {{ source('creator-platform', 'payments') }}
)

select
    payment_id,
    creator_id,
    cast(amount_cents as numeric) / 100                         as amount_eur, 
    lower(status)                                               as status,
    cast(created_at as timestamp)                               as paid_at,
    date(cast(created_at as timestamp), 'Europe/Amsterdam')     as payment_date,
    cast(_loaded_at as timestamp)                               as loaded_at
from source
qualify row_number() over (partition by payment_id order by _loaded_at desc) = 1