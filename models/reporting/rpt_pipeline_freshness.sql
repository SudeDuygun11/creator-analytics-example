-- Grain: one row. A view, so hours_since_load is computed at query time.
select
    max(loaded_at) as last_loaded_at,
    timestamp_diff(current_timestamp(), max(loaded_at), hour) as hours_since_load
from {{ ref('stg_payments') }}