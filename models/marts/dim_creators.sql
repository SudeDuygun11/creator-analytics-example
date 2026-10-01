-- Grain: one row per creator.

with creators as (
    select * from {{ ref('stg_creators') }}
),

payments as (
    select * from {{ ref('int_payments_with_refunds') }}
),

creator_activity as (
    select
        creator_id,
        min(payment_date) as first_revenue_date,
        max(payment_date) as last_revenue_date
    from payments
    group by creator_id
)

select
    c.creator_id,
    c.handle,
    c.country_code,
    c.plan,
    c.created_at,
    a.first_revenue_date,
    a.last_revenue_date
from creators as c
left join creator_activity as a
    using (creator_id)