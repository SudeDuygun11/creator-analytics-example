-- Grain: one row per creator with revenue in the last 90 complete days.
with creator_revenue as (
    select creator_id, handle, sum(net_revenue_eur) as net_revenue_eur
    from {{ ref('rpt_creator_daily_revenue') }}
    where revenue_date between date_sub(current_date('Europe/Amsterdam'), interval 90 day)
                           and date_sub(current_date('Europe/Amsterdam'), interval 1 day)
    group by 1, 2
)

select
    creator_id,
    handle,
    net_revenue_eur,
    row_number() over (order by net_revenue_eur desc, creator_id) as revenue_rank,
    sum(net_revenue_eur) over (order by net_revenue_eur desc, creator_id
                               rows between unbounded preceding and current row)
        / sum(net_revenue_eur) over () as cumulative_revenue_share,
    row_number() over (order by net_revenue_eur desc, creator_id)
        / count(*) over () as cumulative_creator_share
from creator_revenue