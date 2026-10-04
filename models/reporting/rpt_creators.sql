-- Grain: one row per creator. A view, so "today" is evaluated at query time.
with creators as (
    select *, date(created_at, 'Europe/Amsterdam') as signup_date
    from {{ ref('dim_creators') }}
),

enriched as (
    select *, date_diff(first_revenue_date, signup_date, day) as days_to_first_revenue
    from creators
)

select
    creator_id,
    handle,
    plan,
    country_code,
    signup_date,
    first_revenue_date,
    last_revenue_date,
    days_to_first_revenue,
    case
        when days_to_first_revenue is null then null
        when days_to_first_revenue = 0 then '1. Same day'
        when days_to_first_revenue <= 7 then '2. Within a week'
        when days_to_first_revenue <= 30 then '3. Within a month'
        when days_to_first_revenue <= 90 then '4. Within 3 months'
        else '5. Later'
    end as time_to_first_revenue_bucket,
    date_diff(current_date('Europe/Amsterdam'), last_revenue_date, day) as days_since_last_revenue,
    if(first_revenue_date is not null, 1, 0) as is_activated,
    if(signup_date < date_sub(current_date('Europe/Amsterdam'), interval 30 day), 1, 0) as is_eligible_for_activation,
    if(last_revenue_date < date_sub(current_date('Europe/Amsterdam'), interval 30 day), 1, 0) as is_dormant
from enriched