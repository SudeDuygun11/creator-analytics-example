--Option: nullif(trim(plan), '') turns empty strings into NULL, so a not_null test can catch them.
select
    id                            as creator_id,
    handle,
    upper(country_code)           as country_code,
    lower(trim(plan))             as plan,
    cast(created_at as timestamp) as created_at
from {{ source('creator-platform', 'creators') }}