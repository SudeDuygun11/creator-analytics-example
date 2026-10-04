-- Grain: one row per month.
with new_creators as (
    select date_trunc(signup_date, month) as month, count(*) as new_creators
    from {{ ref('rpt_creators') }}
    group by 1
),

earning_creators as (
    select date_trunc(revenue_date, month) as month, count(distinct creator_id) as earning_creators
    from {{ ref('fct_creator_daily_revenue') }}
    group by 1
)

select
    month,
    coalesce(n.new_creators, 0)      as new_creators,
    coalesce(e.earning_creators, 0)  as earning_creators
from new_creators as n
full outer join earning_creators as e
    using (month)