-- Grain: one row per creator per day per revenue component.
select
    f.creator_id,
    f.handle,
    f.plan,
    f.country_code,
    f.revenue_date,
    b.component,
    b.amount_eur
from {{ ref('rpt_creator_daily_revenue') }} as f
cross join unnest([
    struct('1. Gross revenue' as component, f.gross_eur as amount_eur),
    struct('2. Refunds', -f.refunded_eur),
    struct('3. Platform fee', -f.platform_fee_eur)
]) as b