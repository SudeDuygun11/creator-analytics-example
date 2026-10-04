-- Grain: one row per creator per Amsterdam day.
select
    f.creator_id,
    c.handle,
    c.plan,
    c.country_code,
    f.revenue_date,
    f.successful_payments,
    f.gross_eur,
    f.refunded_eur,
    f.platform_fee_eur,
    f.net_revenue_eur
from {{ ref('fct_creator_daily_revenue') }} as f
left join {{ ref('dim_creators') }} as c
    using (creator_id)