-- Grain: one row per successful payment, with its refunds and platform fee.

with payments as (
    select * from {{ ref('stg_payments') }}
),

refunds as (
    select * from {{ ref('stg_refunds') }}
),

refunds_per_payment as (
    -- Aggregate first, so the join cannot duplicate payments (fanout)
    select
        payment_id,
        sum(refund_eur) as refunded_eur
    from refunds
    group by payment_id
)

select
    p.payment_id,
    p.creator_id,
    p.payment_date,
    p.amount_eur                                            as gross_eur,
    coalesce(r.refunded_eur, 0)                             as refunded_eur,
    round(p.amount_eur * {{ var('platform_fee_rate') }}, 2) as platform_fee_eur
from payments as p
left join refunds_per_payment as r
    using (payment_id)  --instead of saying on simplified version
where p.status = 'succeeded'