-- Grain: one row per creator per day (Europe/Amsterdam).
-- Net revenue = successful payments - refunds on those payments - platform fee.

{{ config(
    partition_by = {'field': 'revenue_date', 'data_type': 'date'},
    cluster_by = ['creator_id']
) }}

with payments as (
    select * from {{ ref('int_payments_with_refunds') }}
)

select
    creator_id,
    payment_date                                         as revenue_date,
    count(*)                                             as successful_payments,
    sum(gross_eur)                                       as gross_eur,
    sum(refunded_eur)                                    as refunded_eur,
    sum(platform_fee_eur)                                as platform_fee_eur,
    sum(gross_eur - refunded_eur - platform_fee_eur)     as net_revenue_eur
from payments
group by creator_id, payment_date